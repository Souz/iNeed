#@Author = Dalia William
#@Author = Mohamed Osama
class Admin::CommentsController < AdminController

	#@author: Dalia William
  #@summary: It calls delete_reported_comments in comments controller and passes the comments' ids as parameters.
  #@paramName: params[:comments_ids] => The ids of the comments chosen by the admin in the reported comments view 
	def delete
		@comments = params[:comment_ids]
		Comment.delete_reported_comments(@comments)
		redirect_to reported_admins_path
	end
   #@author = Mohamed Osama
  #@summary = An action which initialzes a list of comments which are reported excluding deleted and hidden comments 
   def reported
     @reported_comments = Comment.where(reported: true).excludes(deleted: true) - Comment.any_in(_id: Admin.find(current_admin.id).hidden_comments) 
    end

  #@author: Dalia William
  #@summary: It first gets the commenters' ids(from the comments ids passed from the view), 
  #          calls warn_customers action (which is in Customer model) than redirects to the reported comments page
  #paramName: params[:reason] => the reason enterred by the admin for warning
  #paramName: params[:comment_ids] => the ids of comments selected by the admin
  def warn
		@reason_for_warning = params[:reason]
    @comments = params[:comment_ids]
    @customers = @comments.map { |comment_id| Comment.find(comment_id).customer.id  }
    Admin.find(current_admin.id).warn_customers(@customers, @reason_for_warning)
    redirect_to reported_admins_path
  end

  #@Author: Tarek Mehrez
  #@Summary: This action gets the checked comments then gets their creators, then ban_marked_customers 
  #are called on current admin
  #@paramName: :comment_ids -> checked comments by the admin 
  #@paramName: :reason -> reason for banning comment creator 
  def ban
    @comments = params[:comment_ids]
    @customers = @comments.map { |comment_id| Comment.find(comment_id).customer.id  }
    Admin.find(current_admin.id).ban_marked_customers(@customers,params[:reason],nil)
    redirect_to reported_admins_path
  end

end

