#Author Omar Aly
class ComplaintsController < ApplicationController
  # GET /complaints
  # GET /complaints.json

#Adding admin's layout in admin_index, since it doesn't belong to the admin's views
#layout "standard", :only => [:admin_index]
  
    layout :choose_layout
    #private
    def choose_layout  
      if current_supplier == nil
        return 'standard'
      else
        return 'supp_master'
      end
    end

 

#Global variable that is used in mark_as_read , mark_as_unread and delete actions to get the ids from the checked boxes
$complaints = []

#Global variable used to check whether there are checked boxes in admiin_index view or not (0->checke/1->checked)
$not_checked = 0

    
#Action that renders the index view for every supplier viewing his complaints
#it redirects to the controller inside of supplier's namespace
  def index
    redirect_to supplier_complaints_url
  end


####################################################################################################

# TAREK - DONE

#Action that renders the admins view of all supplier's complaints to delete them, mark them as read or unread
def admin_index
    #Gets all complaints messages, saves them in variable allcomplaints, passed to the view
    @allcomplaints = Complaint.all
end 
#----------------------------------------------------------------------------------------------
  #Action responsible for marking checked complaints as read
def mark_as_read  
  $complaints = params[:complaint_ids] #gets checked complaint ids from boxes passed to the action, saves them in global variable $complaints
  if ($complaints == nil) #checks if $complaints is nil, therefore no boxes were checked
    $not_checked = 1 #if yes, $not_checked is set to 1 , which means no boxes where checked
      
  else # by reaching this part it means that we had some checked boxes
    $complaints.each do |id| # loop on each id in the complaints ids passed from the checked boxes
      Complaint.find(id).update_attributes(read: true) #setting attribute read in this certain complaint to true
      end
    end 
  redirect_to admin_index_path #this redirects to the same view again, after updating read in the checked complaints to true, more like refreshing
end

#----------------------------------------------------------------------------------------------
#Action responsible for marking checked complaints as unread
def mark_as_unread  
  $complaints = params[:complaint_ids] #gets checked complaint ids from boxes passed to the action, saves them in global variable $complaints
  if ($complaints == nil) #checks if $complaints is nil, therefore no boxes were checked
    $not_checked = 1 #if yes, $not_checked is set to 1 , which means no boxes where checked
 
  else # by reaching this part it means that we had some checked boxes
    $complaints.each do |id| # loop on each id in the complaints ids passed from the checked boxes
        Complaint.find(id).update_attributes(read: false) #setting attribute read in this certain complaint to false
      end
    end 
  redirect_to admin_index_path #this redirects to the same view again, after updating read in the checked complaints to true, more like refreshing
end
#----------------------------------------------------------------------------------------------

#Action responsible for deleting checked complaints
def delete_message
  $complaints = params[:complaint_ids] #gets checked complaint ids from boxes passed to the action, saves them in global variable $complaints
  if ($complaints == nil) #checks if $complaints is nil, therefore no boxes were checked
    $not_checked = 1 #if yes, $not_checked is set to 1 , which means no boxes where checked
 
  else # by reaching this part it means that we had some checked boxes
    $complaints.each do |id| # loop on each id in the complaints ids passed from the checked boxes
        Complaint.find(id).delete #Delete this certain complaint with this id
      end
    end 
  redirect_to admin_index_path #this redirects to the same view again, after updating read in the checked complaints to true, more like refreshing
  end
 


#----------------------------------------------------------------------------------------------
#Action responsible for navigation through other actions handling the admin's complaints view, by taking the submitted
#button as a passed parameter through params[:commit], check which button was clicked, perform the action according to it 
 def admin_index_redirect
    if (params[:commit] == 'Delete') #checking if the clicked(submitted & passed) button was delete
      delete_message #call the delete_message action
    elsif (params[:commit] == 'mark as read') #checking if the clicked(submitted & passed) button was mark as read
      mark_as_read #call the mark_as_read action
    elsif (params[:commit] == 'mark as unread') #checking if the clicked(submitted & passed) button was mark as unread
      mark_as_unread #call the mark_as_unread action
    end
  end
##########################################################################################################
  
  # GET /complaints/1
  # GET /complaints/1.json
  def show
    
    @complaint = Complaint.find(params[:id])
    if(current_admin != nil)
      Complaint.find(params[:id]).update_attributes(read: true)
    end
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @complaint }
    end
  end

  # GET /complaints/new
  # GET /complaints/new.json
  #Action that enables the supplier to view a form to create a new Complaint
  def new
    @complaint = Complaint.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @complaint }
    end
  end

  # GET /complaints/1/edit
  #Action that enables the supplier to view a form to Edit a Complaint
  def edit
    @complaint = Complaint.find(params[:id])
  end

  # POST /complaints
  # POST /complaints.json
  #Action that enables the supplier to save the data inputed in the form as a new entrance in the database
  def create
    @complaint = Complaint.new(params[:complaint])
    @complaint.supplier_id = current_supplier.id

    respond_to do |format|
      if @complaint.save
        format.html { redirect_to @complaint, notice: 'Complaint was successfully created.' }
        format.json { render json: @complaint, status: :created, location: @complaint }
      else
        format.html { render action: "new" }
        format.json { render json: @complaint.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /complaints/1
  # PUT /complaints/1.json
  #Action that enables the supplier to update the data inputed in the form in the respective entrance of the complaint database
  def update  
    @complaint = Complaint.find(params[:id])

    respond_to do |format|
      if @complaint.update_attributes(params[:complaint])
        format.html { redirect_to @complaint, notice: 'Complaint was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @complaint.errors, status: :unprocessable_entity }
      end
    end
  end

 #Author = Omar Aly
 #Deletes a complaint by setting its deleted attribute to true
 #Parameters(:id) which is the complaints id
  def updatedelete
    @complaint = Complaint.find(params[:id])
    @complaint.update_attributes(deleted: false)
    redirect_to supplier_complaints_url
  end
end
