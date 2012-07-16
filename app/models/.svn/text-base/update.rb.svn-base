class Update
  #@Author: Nourhan Aloush
  include Mongoid::Document
  field :content, type: String
  field :type, type: String 
  #offer-c-d: for customers concerning offer they are subscribed to is deleted
  #offer-c-a: for customers concerning offer they are subscribed to is activated
  #need-c: for customers concerning need they need
  #offer-s-d: for supplier concerning his own offer if expired
  #offer-s1: for supplier concerning his own offer when reach 25%
  #offer-s2: for supplier concerning his own offer when reach 50%
  #offer-s3: for supplier concerning his own offer when reach 75%
  #offer-s-a: for supplier concerning his own offer if ready to be activated
  #need-s: for supplier concerning tracked need
  #warn-s: for supplier stating he is warned
  #warn-c: for customer stating he is warned
  #ban-s: for supplier stating he is banned
  #ban-c: for customer stating he is banned
  #delete-c: for deleting comment
  #delete-n: for deleting need
  #notify-s: for a certain need chosen by the supplier to receive notifications on it
  #offer-s-deleted: for supplier if the need which he has offer on is deleted

  field :date, type: Date, default: Time.now
  field :read, type: Boolean, default: false

#relations with other models
  has_and_belongs_to_many :customers
  belongs_to :supplier
  belongs_to :offer
  belongs_to :need
  
#validates that type is entered
  validates_presence_of :type, :message => "type shouldn't be empty"
#callback to call edit_update after creating the update
  before_create :edit_update


#@Author: Nourhan Aloush
#@Summary: This method classify each type of the updates
# => and then sends it to the right corresponding customer or supplier
# It assumes that the type is entered, and each of them takes another parameter
  def edit_update
  
    #send supplier
    if((self.type <=> 'warn-s') == 0)
      self.content = "you are warned"
  
    #send supplier
    elsif((self.type <=> 'ban-s') == 0)
      self.content = "you are banned"

    #send customer id 
    elsif((self.type <=> 'warn-c') == 0)
      self.customers << User.find(self.customer_id)
      self.content = "you are warned"
  
    #send customer id 
    elsif((self.type <=> 'ban-c') == 0)
      self.customers << User.find(self.customer_id)
      self.content = "you are banned"

    #send offer id and supplier id
    self.offer = Offer.find(self.supplier_id)
    elsif((self.type <=> 'offer-s-a') == 0)
      self.offer = Offer.find(self.offer_id)
      self.content = 'you can activate the offer on ' + @offer.need.name + " now !"
  
    #send offer id and supplier id
    elsif((self.type <=> 'offer-s-d') == 0)
      self.supplier = Supplier.find(self.supplier_id)
      self.offer = Offer.find(self.offer_id)
      self.content = 'The offer on ' + @offer.need.name + " is expired"
  
    #send offer id 
    elsif((self.type <=> 'offer-c-d') == 0)
      self.offer = Offer.find(self.offer_id)
      @transactions = Transaction.where(offer_id: self.offer_id)
      @transactions.map { |trans|  self.customers.concat(trans.customer)} 
      self.content = 'This offer ' + @offer.need.name + ' is deleted by its owner'
  
    #send offer id 
    elsif((self.type <=> 'offer-c-a') == 0)
      self.offer = Offer.find(self.offer_id)
      @transactions = Transaction.where(offer_id: self.offer_id)
      @transactions.map { |trans|  self.customers.concat(trans.customer)} 
      self.content = 'This offer on ' + @offer.need.name + ' is activated'
  
    #send need id and supplier id
    elsif((self.type <=> 'notify-s') == 0)
      self.need = Need.find(self.need_id)
      self.supplier = Supplier.find(self.supplier_id)
      self.content = 'This need ' + @need.name + ' reached the required number' 
  
    #send need id
    elsif((self.type <=> 'need-c') == 0)
      self.need = Need.find(self.need_id)
      self.customers = @need.customers
      self.content = 'This need ' + @need.name + ' has a new offer'

    #send offer_id, supplier_id
    elsif((self.type <=> 'offer-s-deleted') == 0)
      self.offer = Offer.find(self.offer_id)
      self.need = self.offer.need
      @transactions = Transaction.where(offer_id: self.offer_id)
      @transactions.map { |trans|  self.customers.concat(trans.customer)} 
      @transactions.map { |trans|  UserMailer.deleted_offer_need_email(trans.customer, offer).deliver}
      self.content = 'The offer on ' + @need.name + ' is deleted because the need is deleted by the admin'
  
    #send customer id and need id
    elsif((self.type <=> 'delete-c') == 0)
      self.need = Need.find(self.need_id)
      self.customers << User.find(self.customer_id)
      self.content = 'your comment on ' + @need.name + ' is deleted'
  
    #send customer id and need_id
    elsif((self.type <=> 'delete-n') == 0)
      self.need = Need.find(self.need_id)
      self.customers = @need.customers
      @need.offers.map { |offer|  offer.update_attribute(:deleted, true)}
      @need.offers.map { |offer|  UserMailer.deleted_offer_need_email(offer.supplier, offer).deliver }
      @need.offers.map { |offer|  Update.create(type: "offer-s-deleted", supplier_id: offer.supplier_id, offer_id: offer.id)}
	  self.content = 'The need ' + @need.name + ' is deleted'
    end
  end




#@Author: Nourhan Aloush
#@Summary: This method checks for updates for the supplier before viewing his own updates
# paramName: "s_id" => supplier_id
def self.check_updates(s_id)
	#search for supplier
	@supplier = User.find(s_id)
	#gets all the offers of this supplier
	@offers = Offer.where(supplier_id: s_id)
	
	#each condition checks for an update, and checks if this update is inserted before or not
	@offers.each do |offer|
		#if the subscribers on the offer exceeded 25%
		if(((offer.num_of_subscribed_quantity/offer.quantity)*100 >= 25) && ((offer.num_of_subscribed_quantity/offer.quantity)*100 < 50))
			@updates = Update.where(supplier_id: s_id, offer_id: offer.id)
			unless @updates.any?{|update| update.type <=> 'offer-s1'}
  				Update.create(type: 'offer-s1', supplier_id: s_id, offer_id: offer.id)
  			end
  		#if the subscribers for the offer exceeded 50%
 		elsif(((offer.num_of_subscribed_quantity/offer.quantity)*100 >= 50) && ((offer.num_of_subscribed_quantity/offer.quantity)*100 < 75))
			@updates = Update.where(supplier_id: s_id, offer_id: offer.id)
			unless @updates.any?{|update| update.type <=> 'offer-s2'}
  				Update.create(type: 'offer-s2', supplier_id: s_id, offer_id: offer.id)
  			end
  		#if the subscribers on the offer exceeded 75%
		elsif(((offer.num_of_subscribed_quantity/offer.quantity)*100 >= 75) && ((offer.num_of_subscribed_quantity/offer.quantity)*100 < 100))
			@updates = Update.where(supplier_id: s_id, offer_id: offer.id)
			unless @updates.any?{|update| update.type <=> 'offer-s3'}
  				Update.create(type: 'offer-s3', supplier_id: s_id, offer_id: offer.id)
  			end
  		#if the offer is ready to be activated
   		elsif(offer.num_of_subscribed_quantity > offer.min_quantity )
			@updates = Update.where(supplier_id: s_id, offer_id: offer.id)
			unless @updates.any?{|update| update.type <=> 'offer-s-a'}
  				Update.create(type: 'offer-s-a', supplier_id: s_id, offer_id: offer.id)
   			end
   		#if the offer is expired
   		elsif(offer.expiry_date < Date.today )
			@updates = Update.where(supplier_id: s_id, offer_id: offer.id)
      		offer.update_attribute(:expired, true)
			unless @updates.any?{|update| update.type <=> 'offer-s-d'}
  				Update.create(type: 'offer-s-d', supplier_id: s_id, offer_id: offer.id)
  			end
  		end
  	end
end
		



#@Author: Nourhan Aloush
#@Summary: This method sets the update as read
  def self.read_update
    update_attributes(read: true)
  end

#@Author: Nourhan Aloush
#@Summary: This method sets the update as unread
  def self.unread_update
    update_attributes(read: false)
  end

 # created a class method which gets the updates for customer
	def self.updates_for_customer(customer_id)
	   self.where(:customer_id => customer_id)
  end

  # created a class method which gets the updates for supplier
  def self.updates_for_supplier(supplier_id)
     self.where(:supplier_id => supplier_id)
  end
 
end
