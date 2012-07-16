#@Author= Alaa Shafaee
#@Author= Tarek Mehrez
#@Author= Nada Nasr
#@Author = Dalia William
class Admin < User

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :email,              :type => String, :null => false, :default => ""
  field :encrypted_password, :type => String, :null => false, :default => ""

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  ## Encryptable
  # field :password_salt, :type => String

  ## Confirmable
  # field :confirmation_token,   :type => String
  # field :confirmed_at,         :type => Time
  # field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  ## Token authenticatable
  # field :authentication_token, :type => String


  field :hidden_comments, :type => Array, default: [] # an array of comment ids hidden by this admin
  field :hidden_needs, :type => Array, default: [] # an array of need ids hidden by this admin
  field :isSuperAdmin, :type => Boolean, default: false
  field :deleted, :type => Boolean, default: false

  # @Author: Nada Nasr
  # @Summary: adds all comment ids in "comments_to_hide" to the array of hidden comments of this admin
  # @paramName: comments_to_hide => ids of comments the admin wants hidden
  def hide_comments(comments_to_hide)
    comments_to_hide.map{|comment_id| update_attribute(:hidden_comments, hidden_comments << BSON::ObjectId.from_string(comment_id))}
  end

  # @Author: Nada Nasr
  # @Summary: adds all need ids in "needs_to_hide" to the array of hidden needs of this admin
  # @paramName: needs_to_hide => ids of needs the admin wants hidden
  def hide_needs(needs_to_hide)
    needs_to_hide.map{|need_id| update_attribute(:hidden_needs, hidden_needs << BSON::ObjectId.from_string(need_id))}
  end  

  #@author: Dalia William
  #@summary: It updates the attribute "reason_for_warning_or_banning" to be false for each customer in the list,
  #          changes the attribute "banned" to be false, and sends an update to the customers to inform 
  #          them that they are warned. These updates are done if the customer is not warned before.
  #@paramName: ids_to_be_warned => A list of customer ids that should be warned
  #@paramName: reason_for_warning => Reason for warning these customers
  def warn_customers(ids_to_be_warned,reason_for_warning)
    ids_to_be_warned.map { |customer_id| Customer.find(customer_id).update_attribute(:banned, "false")}
    ids_to_be_warned.map { |customer_id| Customer.find(customer_id).update_attribute(:reason_for_warning_or_banning, reason_for_warning)}
    ids_to_be_warned.map { |customer_id| Update.create(customer_id: customer_id, type: "warn-c")}
  end

  #@author: Dalia William
  #@summary: It updates the attribute "reason_for_warning_or_banning" to be false for each supplier in the list,
  #          changes the attribute "banned" to be false, and sends an update to the suppliers to inform
  #          them that they are warned. These updates are done if the supplier is not warned before.
  #@paramName: ids_to_be_warned => A list of supplier ids that should be warned
  #@paramName: reason_for_warning => Reason for warning these suppliers
  def warn_suppliers(ids_to_be_warned , reason_for_warning)
    ids_to_be_warned.map { |supplier_id| Supplier.find(supplier_id).update_attribute(:banned, "false")}
    ids_to_be_warned.map { |supplier_id| Supplier.find(supplier_id).update_attribute(:reason_for_warning_or_banning, reason_for_warning) }
    ids_to_be_warned.map {|supplier_id| Update.create(supplier_id: supplier_id, type: "warn-s")}
  end



  #@Author: Alaa Shafaee
  #@summary: returns a list of admins. The method allows for pagination where
  #          a maximum of 10 admins show on page.
  #@paramName: "page" => The page where the pagination is to be applied.
  def self.get_admins(page)
    Admin.all.paginate :page=>page, :order=>'created_at desc', :per_page=>10
  end

  #@Author: Alaa Shafaee
  #@summary: boolean action that deletes an admin by setting the "deleted" attribute to true.
  #@paramName: "admin_id" => The id of the admin to be deleted.
  def self.destroy_admin(admin_id)
    @admin = Admin.find(admin_id)
    @admin.update_attribute(:deleted, "true")
  end
  
  
  #@Author: Tarek Mehrez
  #@Summary: ban all suppliers who had their ids checked and passed from the view, send them an email to infrom them
  #@paramName: ids -> are the ids checked to be banned
  #@paramName: reason_for_banning -> reason entered by admin for banning
  def ban_marked_suppliers(ids,reason_for_banning)
    @suppliers = Supplier.find(ids)
    @suppliers.map { |supp| supp.update_attribute(:banned, "true") }
    @suppliers.map { |supp| supp.update_attribute(:reason_for_warning_or_banning , reason_for_banning)  }
    @suppliers.map { |supp| UserMailer.banning_mail(supp).deliver }
    @suppliers.map { |supp| supp.handle_banned_suppliers  }
  end



  #@Author: Tarek Mehrez
  #@Summary: ban all customers who had their ids checked and passed from the view, send them an email to infrom them
  #@paramName: ids -> are the ids to be banned 
  #@paramName: reason_for_banning -> reason entered by admin for banning
  def ban_marked_customers(ids,reason_for_banning,need_ids)
    @customers = Customer.find(ids)
    @customers.map { |cust| cust.update_attribute(:banned, "true") }
    @customers.map { |cust| cust.update_attribute(:reason_for_warning_or_banning , reason_for_banning)  }
    @customers.map { |cust| UserMailer.banning_mail(cust).deliver }
    unless need_ids.nil?
      Need.find(need_ids).map { |need| need.update_attribute(:deleted,"true")  }
    end
    @customers.map { |cust| cust.handle_banned_customers  }
  end

  #@Author: Tarek Mehrez
  #@Summary: mark complaints who had their ids checked in the view as read
  #@paramName: complaints -> complaints ids that are checked and passed through the controller
  def mark_as_read(complaints)
    Complaint.find(complaints).map { |c| c.update_attribute(:read, "true")  }
  end

  #@Author: Tarek Mehrez
  #@Summary: mark complaints who had their ids checked in the view as unread
  #@paramName: complaints -> complaints ids that are checked and passed through the controller
  def mark_as_unread(complaints)
    Complaint.find(complaints).map { |c| c.update_attribute(:read, "false")  }
  end
   
  #@Author: Tarek Mehrez
  #@Summary: deltee complaints who had their ids checked in the view
  #@paramName: complaints -> complaints ids that are checked and passed through the controller
  def delete_complaint(complaints)
    Complaint.find(complaints).map { |c| c.update_attribute(:deleted,"true")  }
  end
  
  # @Author: Nada Nasr
  # @Summary: sets approved to true and sends the corresponding supplier an approval email
  # @paramName: supplier_id => the id of the supplier to be approved
  def approve_supplier(supplier_id)
    if (Supplier.find(supplier_id).approved == nil)
      Supplier.find(supplier_id).update_attribute(:approved, "true")
      UserMailer.approve_email(Supplier.find(supplier_id)).deliver
    end
  end

  # @Author: Nada Nasr
  # @Summary: sets approved to false and sends the corresponding supplier a rejection email
  # @paramName: supplier_id => the id of the supplier to be rejected
  def reject_supplier(supplier_id)
    if (Supplier.find(supplier_id).approved == nil)
      Supplier.find(supplier_id).update_attribute(:approved, "false")
      UserMailer.reject_email(Supplier.find(supplier_id)).deliver
    end
  end
  
end
