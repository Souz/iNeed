#@Author: "Doha"
#@Author: "Nourhan Aloush"
class Offer
  include Mongoid::Document
 #the needed values to create an offer
 
  field :num_of_subscribed_quantity, type: Integer, default: 0
  field :deleted, type: Boolean, default: false
  field :expired, type: Boolean, default: false
  field :quantity, type: Integer
  field :min_quantity, type: Integer
  field :price, type: BigDecimal, precision: 8, scale: 2
  field :expiry_date, type: Date
  field :description, type: String
  field :warranty, type: Integer
  field :published, type: Boolean, default: false
  field :published_date, type: Date, default: Date.today
  field :activated, type: Boolean, default: false
  field :last_modified, type: Date, default: Date.today
  field :quantity_error, type: Boolean, default: true

#validations of the input values
  validates_numericality_of :quantity,:greater_than_or_equal_to => 0, :only_integer => true, :message => "can only be positive whole number."
  validates_numericality_of :min_quantity, :greater_than_or_equal_to => 0, :only_integer => true, :message => "can only be positive whole number."
  validates_presence_of :quantity, :message => "shouldn't be blank"
  validates_presence_of :price, :message => "shouldn't be empty"
  validates_numericality_of :price, :greater_than_or_equal_to => 0, :message => "This should be a positive number"
  validates_numericality_of :warranty, :greater_than_or_equal_to => 0, :only_integer => true, :message => "This should be a positive number"

  before_create :quantity_value


#@Author: Nourhan Aloush
#@Summary: This method makes sure that the min_quantity is less than the quantity itself
# => if not, it sets the min_quantity to the quantity automatically
# => It is a callback which is called before creating the offer
  def quantity_value
    if (self.quantity < self.min_quantity)
		self.quantity_error = false
    	self.min_quantity = self.quantity
    end
  end

#relations between offer and other models
  has_many :updates
  belongs_to :supplier
  belongs_to :need
  has_many :transactions

#method to increment number of needed quantity
  def increment_quantity(quantity)
    self.update_attribute(:num_of_subscribed_quantity, self.num_of_subscribed_quantity + quantity)
  end

#Author: Nourhan Aloush
#@Summary: This checks if the num of subscribed customers reached the required number
# => it adds an update to this supplier
#@ParamName: "offer_id" => The id of the offer
#@ParamName: "supplier_id" => The id of the supplier
  def check_for_update(offer_id, supplier_id)
    if(num_of_subscribed_quantity >= quantity)
      offer.updates.push(Update.new(offer_id, supplier_id, "offer-s-a"))
    end
  end
#Author: Sarah El-Sherbiny
#@summary: class method to order all offers desc by the number of offers per need
  def self.order_offers_by_percentage
    self.order_by([[:percentage, :desc]])  
  end
 #Author :: Sarah El-Sherbiny
 #@summary: a method to return all offers on a need for one customer  
  def self.list_subscribed_offers(need_id,customer_id) 
    my_subscribed_offers = []
    transactions = []
    offers = self.where(:need_id => need_id)
    offers.each do |offer|
      transactions = Transaction.get_transactions_for_offer(offer.id)
      transactions.each do |transaction|
        if(transaction.customer_id == customer_id)
          my_subscribed_offers << offer
        end
      end
    end
      my_subscribed_offers
  end


  #a method that gets the offers placed on a certain need 'n', its takes n_id as a parameter inorder to filter offers for this need
  def get_offers (need_id)
    begin  
      @offers = Offer.where(:need_id => need_id)
    rescue
      raise "No offers were found for this need"
    end
  end  

  #checks if this offer is expired 
  def self.check_expired
  	if(self.expiry_date > Date.today )
  		self.update_attributes(expired: 'true')
  	end
  end
  #<Author> Sarah El-Sherbiny </Author>
  #class method to get offers of a supplier
  def self.get_offers_for_supplier(supplier_id)
    self.where(:supplier_id => supplier_id)
  end



  def self.get_offers_for_supplier(supplier_id)
    self.where(:supplier_id => supplier_id)
  end

  #Author: "Doha"
  #@Summary: This method gets an array of offers belonging to a certain need, then sort them according to their price,
  #then reverse is used to reverse the order of the list to be desc instead of asc"
  def self.sorting_offers_desc(need_id)
    most_expensive_offer = []
    list_reversed =[]
    offers_list = self.where(:need_id => need_id).to_a
    list_reversed = offers_list.sort_by{|s| s.price}.reverse
    most_expensive_offer << list_reversed[0]
  end


  #Author: "Doha"
  #@Summary: This method gets an array of offers belonging to a certain need, then sort them according to their price
  def self.sorting_offers_asc(need_id)
    least_offer = []
    offers_list = self.where(:need_id => need_id).to_a
    offers_list.sort_by{|s| s.price} 
    least_offer << offers_list[0]
  end
end



