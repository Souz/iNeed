#@Author = Dalia William
#@Author = Nourhan Azab
#@Author = Nisma El-Nayeb
#@Author = Mirna ElBendary
#@Author= Yousra Hazem


class Need
  #@author: Amir Emad
  include Mongoid::Document
  include Mongoid::Paperclip
  include Tire::Model::Search
  include Tire::Model::Callbacks

  #Embedded tire in the model for searching
  #mapped the fields name and description to elasticsearch which mean we will search on these fields
  mapping do
    indexes :name
    indexes :description
    indexes :category_name
  end
  field :reported, type: Boolean
  field :records, type: Hash, default: Hash.new
  field :report, type: String
  field :name, type: String # this needs name
  field :description,type: String # a description of this need
  field :deleted, type: Boolean
  field :hot_need, type: Boolean
  field :total_needers, type: Integer, default: 0 # the total number of needers for this need
  field :array_of_locations, type:Array, default: Array.new
  field :category_name, type:String # category name belonging to this category
  field :num_reports_on_need_before_deletion, type: Integer, default: 3
  field :num_of_needers_in_locations, type: Hash, default: Hash.new
  field :published_date, type: Date, default: Date.today
  field :num_of_needers_in_locations, type: Hash, default: Hash.new # needed quantities in different locations


  has_and_belongs_to_many :suppliers
  has_and_belongs_to_many :customers # a list of customers who need this need
  has_many :comments


  belongs_to :category # the category to which this need belongs
 

  belongs_to :customer #creator_customer
  has_many :offers #stores offers on this need
  has_many :updates # stores updates on this need
 
  # photo 
  has_mongoid_attached_file :photo,  
  :styles =>{ :normal => "70x70>", :small => "70x70" },
  :url => "/assets/needs/:id/:style/:basename.:extension",
  :path => ":rails_root/public/assets/needs/:id/:style/:basename.:extension",
  :default_url => 'noimageavailable.jpg'


  #validations
  validates_uniqueness_of :name,:message => "already exists" #check need name is unique
  validates_uniqueness_of :name, :if => :deleted?, :scope => :deleted, :message => "was banned by admin before! You are not allowed to create a need with this name!"
  #check need is not banned
  validates_length_of :name, minimum: 2, maximum: 40, :message => "must be between 2 and 40 characters"
  #check length of description between 2 and 40
  validates_presence_of :name, :message => "shouldn't be blank"
  #check name is not blank 
  validates_presence_of :description, :message => "shouldn't be empty"
  #check description is not blank
  validates_attachment_size :photo, :less_than => 2.megabytes
  #check photo size less than 2 MBs
  validates_attachment_content_type :photo, :content_type => ['image/jpeg','image/png','image/gif']
  #check photo type is jpeg,gif or png
  validates_presence_of :category_name, :message => "should be entered"
  #check category of this need is entered

  #@Author: Yousra Hazem
  #@summary: Locate needer is called when a customer clicks iNeed, to add the quantity he needs to a certain location in the hash of locations and quantities, if that locaton exists. If the location doesn't exist then the location is added to the hash of locations. 
  #@paramName: "location" => the location of the customer and it is used as a key in the hash.
  def locate_needer(location)
    if !self.num_of_needers_in_locations[location].nil?
      self.num_of_needers_in_locations[location] += 1
    else
      self.num_of_needers_in_locations[location] = 1 
    end
  end
  #@Author: Yousra Hazem
  #@summary: delocate needer is called when a customer clicks un_need, to remove the quantity he used to need from a certain location in the hash of locations and quantities, if that locaton exists. If after deducting his needs, the quantity of this location is < 0 then the quanity is set to zero
  #@paramName: "location" => the location of the customer and it is used as a key in the hash.  
  def delocate_needer(location)
    if !self.num_of_needers_in_locations[location].nil?
      if self.num_of_needers_in_locations[location] > 0
        self.num_of_needers_in_locations[location] -= 1
      else
        self.num_of_needers_in_locations[location] = 0
      end
    else
      self.num_of_needers_in_locations[location] = 0
    end
  end
  
  #@Author = Mirna ElBendary
  #@summary = checks if the number of needers in a certain location is equal to that entered by the user 
  #and stored in the array. if so, then a notification is sent.
  #@paramName: location_quantity = the array of need_id, location and number of needers.
  def notify#(location, number)
    Supplier.notify_array.each do |location_quantity|
      if (need_id == location_quantity[0])
        if (self.num_of_needers_in_locations[location_quantity[1]] == location_quantity[2])
          Update.create(type: 'notify-s', need_id: params[:id], supplier_id: s_id)
        end
      end
    end  
  end
  

  #@Author: Nisma El-Nayeb
  #@Summary: Gets a specific need object
  #@paramName: "id" => ID of need object we want to retrieve
  def self.get_need(id)
    self.find(id)
  end


  #@author: Amir Emad
  #@summary: Checks if there's an offer within the need whose offer is greater than price.
  #@paramname: "price" => Price to be compared with
  def price_greater?(price)
    self.offers.each do |offer|
      if offer.price >= price and !offer.deleted
        return true
      end
    end
    return false
  end
  #@author: Amir Emad
  #@summary: Checks if there's an offer within the need whose offer is less than price.
  #@paramname: "price" => Price to be compared with
  def price_less?(i)
    self.offers.each do |offer|
      if offer.price <= i and !offer.deleted
        return true
      end
    end
    return false
  end

  def has_start(q)
    name = self.name.downcase.split
    name.each do |subname|
      if subname.start_with?(q)
        return true
      end
    end
    return false
  end
  #@author: Nourhan Azab
  #@summary:returns whether the current logged in customers needs this need or not
  #@current_customer: the current logged in customer 
  def is_needer(current_customer)
    customers.include?(current_customer)
  end
  # class method to order all needs desc by the number of offers per  need and returns the most 5 hot needs in an array for the customer
  def self.order_by_numberOfoffers
   self.order_by([[:offers, :desc]])
  end
#author: Nourhan Azab
#@summary: instance method to get whether a need is deleted or not to be used in validations
 def deleted?
    return deleted
 end
 
 # decrements the quantity of needs when the customer subscribes to an offer 
  def decrement_quantity(needed_quantity)
    self.total_needers -= @needed_quantity
  end


  #@author: Dalia William
  #@summary: It deletes the needs and sends an update to each need's creator to inform him about the deletion
  #@paramName: ids_to_be_deleted => A list that contains the ids of the needs to be deleted
  def self.delete_reported_needs(ids_to_be_deleted)
    ids_to_be_deleted.map { |need_id| Need.find(need_id).update_attribute(:deleted, 'true')}
    ids_to_be_deleted.map { |need_id| Update.create(customer_id: Need.find(need_id).customer.id, need_id: need_id, type: "delete-n")  }
  end

  #@author: Dalia William
  #@summary: It checks whether the number of reports on the need exceeds num_reports_on_need_before_deletion.
  #          If the need exceeds it, its "deleted" attribute is set to true, an update is sent to the need's creator
  #          and the creator's attribute "number_of_needs_deleted_by_system" is incremented by one. At the end, the 
  #          action checked_num_deleted_needs is called to check whether we should warn/ban the need's creator
  #@paramName: need_id => The id of the need to be checked
  def self.check_num_reports_on_need(need_id)
    @num_reports = Need.find(need_id).records.length
  
    if (@num_reports >= Need.find(need_id).num_reports_on_need_before_deletion)
      Need.find(need_id).update_attribute(:deleted, 'true')
      @customer_id = Need.find(need_id).customer.id

      Update.create(customer_id: @customer_id, need_id: need_id, type: "delete-n")

      @number_deleted_needs = Customer.find(@customer_id).number_of_needs_deleted_by_system + 1
      Customer.find(@customer_id).update_attribute(:number_of_needs_deleted_by_system, @number_deleted_needs)
      Customer.find(@customer_id).checked_num_deleted_needs   
    end
  end

  #method that returns needs of the day 
  def self.get_needs_of_the_day
    self.where(:published_date => Date.today)
  end
end

