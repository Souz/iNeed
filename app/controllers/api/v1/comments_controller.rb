#@author: Marina Charles
class Api::V1::CommentsController < Api::V1::BaseController
  before_filter :restrict_access, :except => [:show, :index]
  respond_to :json

  def index
    respond_with Comment.all
  end

  def show
    respond_with Comment.find(params[:id])
  end
#@author: Marina Charles
#@summary: in this action i put in xml file the comment to be able to delete it using respond_with

   def destroy
      respond_with Comment.destroy(params[:id])
    end

  def reportcomment
    commentID = params["comment_id"]
    @comment = Comment.find(commentID)
    cust_id = current_customer.id.to_s
    report_type = params["reportcomment"]
    @comment.reportcomment = report_type.to_s
    @comment.update_attributes(reported: true)
    @comment.recordscomment[cust_id]= @comment.reportcomment
    @comment.save
    respond_with @need
  end

  def create
    @comment = @need.comments.build(params[:comment])
    respond_with @comment.save
  end
end
