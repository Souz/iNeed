#@Author = Dalia William
#@Author = Nisma El-Nayeb
#@Author = Doha
class Comment
  include Mongoid::Document
  include Mongo::Voteable
  field :reported, type: Boolean #check if that comment is reported or not
  field :reported_comments, type: Hash, default: Hash.new #stores the cutomer ID as its key and the reason why the customer reports a comment as the type opposite to that key.
  field :report_reason, type: String #stores the reason choosed by the customer for reporting a comment
  field :deleted, type: Boolean #check if that comment is deleted or not
  field :content, type: String #this attribute is where the comments is written.

  field :num_reports_on_comment_before_deletion, type: Integer, default: 3
  field :created_on, type: DateTime, default: Time.now #this attribute is to get the current date and time at which the comment was posted.
  belongs_to :user
  belongs_to :need #this indicates that comments has realtion with needs where it belongs to it
  belongs_to :customer #this indicates that comments has realtion with customer where it belongs to it

  #@Author: Doha
  #@Summary: validates that the comment is not empty
  validates_presence_of :content

  #@Author: Nisma El-Nayeb
  #@Summary: makes comments voteable using voteable_mongo gem
  voteable self, :up => +2, :down => -1

  #@author: Dalia William
  #@summary: It deletes the comments and sends an update to each commenter to inform him about the deletion
  #@paramName: ids_to_be_deleted => A list that contains the ids of the comments to be deleted
  def self.delete_reported_comments(ids_to_be_deleted) 
    ids_to_be_deleted.map { |comment_id| Update.create(customer_id: Comment.find(comment_id).customer.id, need_id: Comment.find(comment_id).need.id , type: "delete-c") }
    ids_to_be_deleted.map { |comment_id| Comment.find(comment_id).destroy }
  end

  #@author: Dalia William
  #@summary: It checks whether the number of reports on the comment exceeds num_reports_on_comment_before_deletion.
  #          If the comment exceeds it, it is deleted from our database, an update is sent to the commenter
  #          and the commenter's attribute "number_of_comments_deleted_by_system" is incremented by one. At the end, the 
  #          action checked_num_deleted_comments is called to check whether we should warn/ban the commenter.
  #@paramName: comment_id => The id of the comment to be checked
  def self.check_num_reports_on_comment(comment_id)
    @num_reports = Comment.find(comment_id).reported_comments.length
    if (@num_reports >= Comment.find(comment_id).num_reports_on_comment_before_deletion)
      @customer_id = Comment.find(comment_id).customer.id
      @need_id = Comment.find(comment_id).need.id
      Comment.find(comment_id).destroy
      Update.create(customer_id: @customer_id,need_id: @need_id, type: "delete-c")

      @number_deleted_comments = ((Customer.find(@customer_id)).number_of_comments_deleted_by_system) + 1
      (Customer.find(@customer_id)).update_attribute(:number_of_comments_deleted_by_system, @number_deleted_comments)
      Customer.find(@customer_id).checked_num_deleted_comments
    end
  end

  #@Author: Nisma El-Nayeb
  #@Summary: Gets a specific comment object
  #@paramName: "id" => ID of comment object we want to retrieve
  def self.get_comment(id)
    self.find(id)
  end
  
end
