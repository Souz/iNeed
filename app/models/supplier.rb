#@Author = Nisma El-Nayeb
#@Author = Tarek Mehrez
class Supplier < User
  include Mongoid::Document
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
  
  
  # Banned = nil --> Supplier not warned nor banned , Banned = false ---> Supplier warned , Banned = true ---> Supplier banned 
  field :banned, :type => Boolean
  field :organization, :type => String
  field :number_of_ratings, :type => Integer, default: 0
  field :rating, :type => Integer, default: 0
  field :approved, :type => Boolean
  # reason_for_warning_or_banning : The reason of warning/banning the supplier
  field :reason_for_warning_or_banning, :type => String
  has_and_belongs_to_many :categories
  has_many :offers
  has_many :updates
  field :notify_array, type:Array, default: Array.new
  has_and_belongs_to_many :needs
  has_many :complaints

  scope :registered_not_banned, where(approved: true).excludes(banned: true) 
  scope :banned_suppliers , where(banned: true)
  scope :unregistered, where(approved: nil)

  # @Author: Nada Nasr
  # @Summary: updates the rating of a supplier given a new rating to be inserted
  def update_rating(new_rating)
    update_attribute(:rating, (rating * number_of_ratings + new_rating) / (number_of_ratings + 1))
    update_attribute(:number_of_ratings, number_of_ratings + 1)
  end
    # a method used when a supplier is tracking the need, it stores the data that determines should he/she get notified
  def track_notify(need_id, location, quantity)
    location_quantity=Array.new
    location_quantity[0,2]=[need_id,location,quantity]
    self.notify_array.push(location_quantity)
  end
  # a method used when a supplier clicks untrack need, to delete date and disabling notification 
  def untrack_notify(need_id)
    self.notify_array.delete_if {|x| x[0] == need_id }
  end

  #@Author: Nisma El-Nayeb
  #@Summary: Checks if supplier of given id banned or not and returns true if the given
  #          supplier is indeed banned
  #@ParamName: "id" => the ID of the supplier
  def self.is_banned(id)
    if self.find(id).banned == true
      true
    else
      false
    end
  end
  
  def unban
    update_attribute(:banned, nil)
  end

  #@Author: Tarek Mehrez
  #@Summary: Deletes all offers of the banned supplier and send the subscribed customers an email to notify them
  #@paramName: s_id -> the banned supplier's id
  def handle_banned_suppliers
    running_offers = Supplier.find(id).offers
    running_offers.each do |offer|
      offer.need.customers.each do |customer|
        UserMailer.banned_supplier_email(Supplier.find(id),customer).deliver
      end
      offer.update_attribute(:deleted, "true")  
    end

  end

  
end

