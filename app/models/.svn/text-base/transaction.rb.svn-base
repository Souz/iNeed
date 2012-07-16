class Transaction
  include Mongoid::Document
  field :done, :type => Boolean, default: false
  field :code, :type => String
  field :pending, :type => Boolean
  field :quantity, :type => Integer, default: 0
  field :deleted, :type => Boolean, default: false




  belongs_to :customer
  #hs_many :supplier
  belongs_to :offer
  has_one :feedback
  

  #validates_presence_of :code, :message => "shouldn't be blank"
  validates_numericality_of :quantity,:greater_than => 0, :only_integer => true, :message => "can only be positive whole number."
  
  #@Author:: Sarah El-Sherbiny 
  #@summary :a method that returns the transaction of an offer to one customer
  def self.returnTransaction(user_id,offer_id)
  	(self.where(:customer_id => user_id,:offer_id => offer_id))[0]
  end
  
  #@Author :: Sarah El-Sherbiny  
  #@summary:class method that returns the transactions for an offer
  def self.get_transactions_for_offer(offer_id)
    self.where(:offer_id => offer_id)
  end
  
  #<Author> Nourhan Azab </Author>  
  #instance method to delete the transaction of a customer on a certain need
  def self.remove_transactions_on_need(need,current_customer)
    self.all.each do |transaction|
      if transaction.customer == current_customer && transaction.offer.need == need
        transaction.delete
      end
    end
  end

  #<Author> Karim Tharwat </Author>
  #a method that turns all the pending offers to non-Pending
  def self.transform_pending_to_non_pending(offer_id)
    @transactions = self.get_transactions_for_offer(offer_id)
    @transactions.each do |transaction|
      transaction.update_attribute(:pending, false)
    end
  end  

  def increment_quantity(quantity)
    self.update_attribute(:quantity, self.quantity + quantity)
  end  

end
