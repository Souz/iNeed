#@Author = Tarek Mehrez
class Admin::ComplaintsController < AdminsController

  #@Author : Tarek Mehrez
	#@Summary: get all complaints in the object @complaints, paginated
	def index
    @complaints = Complaint.excludes(deleted: true).paginate :page=>params[:page], :order=>'created_at desc', :per_page=>3
    respond_to do |format|
    	format.html # index.html.erb
    	format.json { render :json => @complaints }
    end
	end

  #@Author : Tarek Mehrez
  #@Summary: show a single complaint with the id passed from index view
  #@paramName: id of the complaint to be shown
	def show
		@complaint = Complaint.find(params[:id])
    @complaint.update_attribute(:read,"true")

	end

  #@Author : Tarek Mehrez
  #@Summary: call mark_as_read on current admin to mark checked complaints as read
  #@paramName: :complaint_ids -> ids of the checked complaints by admin
	def mark_as_read  
		Admin.find(current_admin.id).mark_as_read(params[:complaint_ids])
    redirect_to admin_complaints_path
	end

  #@Author : Tarek Mehrez
  #@Summary: call mark_as_unread on current admin to mark checked complaints as unread
  #@paramName: :complaint_ids -> ids of the checked complaints by admin
	def mark_as_unread  
  	Admin.find(current_admin.id).mark_as_unread(params[:complaint_ids]) 
    redirect_to admin_complaints_path
	end

  #@Author : Tarek Mehrez
  #@Summary: call delete on current admin delete checked complaints
  #@paramName: :complaint_ids -> ids of the checked complaints by admin
  def delete
    Admin.find(current_admin.id).delete_complaint(params[:complaint_ids]) 
    redirect_to admin_complaints_path
  end
end
