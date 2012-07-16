#Author: Omar Aly
class Complaint
  include Mongoid::Document
  field :date, type:Time, default: -> { Time.now }
  field :content, type: String
  field :subject, type: String
  field :read, type: Boolean, default: false
  field :deleted, type: Boolean, default: false

  belongs_to :supplier
#Method to update a complaint's read status to True
	def set_Read
		this.update_attributes(read: true)
	end
	def set_Unread
#Method to update a complaints read status to false
		this.update_attributes(read: false)
	end
#Method to delete a complaint
	def delete
		this.update_attributes(deleted: true)
	end
end
