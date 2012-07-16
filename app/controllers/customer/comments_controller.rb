 #@Author = Doha
 class Customer::CommentsController < ApplicationController



#@Author: "Doha"
#@summary: This action gets the customer ID of a certain comment and saves it as the key of the hash called "recordscomment",
#then it gets the reason why the customer reported this comment and saves it as the value opposite to his ID in the hash,
#and finally it updates the reported boolean to true to indicate that this comment is reported.
#@commentID => gets the comment ID 
#report_type => gets the reason why the customer reported this comment.     
  def report_comment
    @comment = Comment.find(params["comment_id"])
    cust_id = current_customer.id.to_s
    @comment.report_reason = params["report_reason"]
    @comment.update_attributes(reported: true)
    @comment.reported_comments[cust_id]= @comment.report_reason
    @comment.save
    Comment.check_num_reports_on_comment(@comment.id)
    redirect_to :back
  end
end

