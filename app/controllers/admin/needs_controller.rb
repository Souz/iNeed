#@Author = Dalia William
#@Author = Mohamed Osama
class Admin::NeedsController < AdminController

	#@author = Dalia William
  #@summary = It calls delete_reported_needs in needs controller and passes the needs' ids as parameters. 
  #@paramName: params[:need_ids] => The ids of the needs chosen by the admin in the reported needs view
	def delete
		@needs = params[:need_ids]
		Need.delete_reported_needs(@needs)
		redirect_to :back
	end
  #@author = Mohamed Osama
  #@summary = An action which initializes a list of needs which are reported excluding deleted and hidden needs
  def reported
    @reported_needs = Need.where(reported: true).excludes(deleted: true) - Need.any_in(_id: Admin.find(current_admin.id).hidden_needs)
   end 

  #@author: Dalia William
  #@summary: It first gets the ids of the needs' creators(from the needs ids passed from the view), 
  #          calls warn_customers action (which is in Customer model) than redirects to the reported needs page
  #paramName: params[:reason] => the reason enterred by the admin for warning
  #paramName: params[:need_ids] => the ids of needs selected by the admin
  def warn
		@reason_for_warning = params[:reason]
    @needs = params[:need_ids]
    @customers = @needs.map { |need_id| Need.find(need_id).customer.id  }
    Admin.find(current_admin.id).warn_customers(@customers, @reason_for_warning)
    redirect_to reported_admins_path
  end

  #@Author: Tarek Mehrez
  #@Summary: This action gets the checked needs then gets their creators, then ban_marked_customers 
  #are called on current admin
  #@paramName: :needs_ids -> checked needs by the admin 
  #@paramName: :reason -> reason for banning need creator 
  def ban
    @needs = params[:need_ids]
    @customers = @needs.map { |need_id| Need.find(need_id).customer.id  }
    Admin.find(current_admin.id).ban_marked_customers(@customers,params[:reason],@needs)
    redirect_to reported_admins_path
  end


end
