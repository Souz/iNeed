#@Author = Nisma El-Nayeb
#@Author = Mohamed Ayman
#@Author = Mohamed Osama
#@Author = Tare Mehrez
class Customer < User
  include Mongoid::Document
  include Mongo::Voter
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
  
  attr_accessible :email, :password, :password_confirmation, :number_of_comments_deleted_by_system, :number_of_needs_deleted_by_system 

  field :banned, :type => Boolean
  field :message, :type =>String
  field :reason_for_warning_or_banning, :type => String
  field :number_of_comments_deleted_by_system, :type => Integer, :default => 0
  field :number_of_needs_deleted_by_system, :type => Integer, :default =>0
  field :num_deleted_needs_before_warn, type: Integer, default: 1
  field :num_deleted_needs_before_ban, type: Integer, default: 2
  field :num_deleted_comments_before_warn, type: Integer,default: 1
  field :num_deleted_comments_before_ban, type: Integer,default: 2

  has_many :authentications
  has_one :need
  has_and_belongs_to_many :updates
  has_many :transactions
  has_many :comments
  has_and_belongs_to_many :needs
  has_many :keys

  #@Author: Nisma El-Nayeb
  #@Summary: Checks if customer of given id banned or not and returns true if the given
  #          customer is indeed banned
  #@ParamName: "id" => the ID of the customer
  def self.is_banned(id)
    if self.find(id).banned == true
      true
    else
      false
    end
  end
  
  #@author: Dalia William
  #@paramName: ids_to_be_warned => A list of customer ids that should be warned
  #@paramName: reason_for_warning => Reason for warning these customers
  #@summary: It updates the attribute "reason_for_warning_or_banning" to be false for each customer in the list,
  #          changes the attribute "banned" to be false, and sends an update to the customers to inform 
  #          them that they are warned. These updates are done if the customer is not warned before.
  def self.warn_customers(ids_to_be_warned, reason_for_warning)
    for customer_id in ids_to_be_warned
      if(Customer.find(customer_id).banned.nil?)
        (Customer.find(customer_id)).update_attribute(:reason_for_warning_or_banning , reason_for_warning)
        (Customer.find(customer_id)).update_attribute(:banned, "false")
        Update.create(customer_id: customer_id, type: "warn-c")
      end
    end
  end
  #@author = Mohamed Osama
  #@summary = checks how many needs are deleted by the system and upon that the customer is either warned or banned
  def checked_num_deleted_needs
    	if(number_of_needs_deleted_by_system == num_deleted_needs_before_warn)
      		update_attribute(:banned, false)
          #Update.create(customer_id: customer_id, type: "warn-c")
    	elsif(number_of_needs_deleted_by_system == num_deleted_needs_before_ban)
      		update_attribute(:banned, true)
          handle_banned_customers
    	end
    
  end
  #@author = Mohamed Osama
  #@summary = checks how many comments are deleted by the system and upon that the customer is either warned or banned
  def checked_num_deleted_comments
    	if(number_of_comments_deleted_by_system == num_deleted_comments_before_warn)
      		update_attribute(:banned, false)
          #Update.create(customer_id: customer_id, type: "warn-c")
    	elsif (number_of_comments_deleted_by_system == num_deleted_comments_before_ban)
      		update_attribute(:banned, true)
          handle_banned_customers
   		end
  end
  def unban
    update_attribute(:banned, nil)
  end

  #@author: Mohamed Diaa
    #@summary: The following action retrieves user information from provider "facebook"
    #           for registering a new user, linking user provider's account to iNeed's
    #           account, retrieving Email, and Name, uid, provider
    #@paramName: "uid" : is the user id at the provider side
    #@paramName: "provider" : is the name of the provider
    def apply_omniauth(omniauth)
    	self.name = omniauth['info']['name'] if name.blank?
      self.email = omniauth['info']['email'] if email.blank?
    	authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
  	end

  #@author: Mohamed Diaa
    #@summary: The following action gives the posibility to create an iNeed account 
    #           without providing required data like password, location
    #           that are missing from provider's data
    #@paramName: "uid" : is the user id at the provider side
    #@paramName: "provider" : is the name of the provider
   def self.create_with_omniauth(auth)
      create! do |customer|
       Customer.provider = auth['provider']
       Customer.uid = auth['uid']
       Customer.name = auth['info']['name']
      end
  end

 	#   def password_required?
    #  	 (authentications.empty? || !password.blank?) && super
    # 	end


  #@Author: Tarek Mehrez
  #@Summary: Delete all needs created by banned customer, unneed all needs which the banned customer did'nt 
  #subscribe to
  #@paramName: c_id -> banned customer's id
  def handle_banned_customers
    @customer = Customer.find(id)
    @comments = @customer.comments
    @comments.delete_all
    @needs = @customer.needs
    @needs.each do |need|
      need.offers.each do |offer|
        if Transaction.where(:customer_id => id,:offer_id => offer.id).empty?
          need.update_attribute(:total_needers, need.total_needers-1)
          need.delocate_needer(@customer.location)
          @customer.needs.delete(need)
          need.customers.delete(@customer)
        
        end   
      end
    end
  end

  #@author = Mohamed Ayman
  #@summary = checks this Customer is subscribed to this offer
  #customer_id : "param 1" => the id of the customer
  #offer_id : "param 2" => the id of the offer 
  #def is_subscribed(customer_id, offer_id)
    #transactions = Transaction.where(:customer_id => customer_id,:offer_id => offer_id)
    #if transactions.empty?
      #false
    #else
      #true
    #end
  #end

 end

