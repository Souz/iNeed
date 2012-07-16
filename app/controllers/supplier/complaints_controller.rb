#Author: Omar Aly
class Supplier::ComplaintsController < SupplierController
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

    
#Action that renders the index view for every supplier viewing his complaints
  def index
    begin
      @complaints = Complaint.where(supplier_id: current_supplier.id, deleted: false).paginate(:per_page => 10,:page => params[:page]) 

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @complaints }
      end
    rescue
      redirect_to :root, notice: "Nice try, but next time you have to be smarter!"
    end 
  end

  # GET /complaints/1
  # GET /complaints/1.json
  def show
    begin
      @complaint = Complaint.find(params[:id])
      if(current_admin != nil)
        Complaint.find(params[:id]).update_attributes(read: true)
      end
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @complaint }
      end
    rescue
      redirect_to :root, notice: "Nice try, but next time you have to be smarter!"
    end 
  end

  # GET /complaints/new
  # GET /complaints/new.json
  #Action that enables the supplier to view a form to create a new Complaint
  def new
    begin
      @complaint = Complaint.new

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @complaint }
      end
    rescue
      redirect_to :root, notice: "Nice try, but next time you have to be smarter!"
    end 
  end

  # GET /complaints/1/edit
  #Action that enables the supplier to view a form to Edit a Complaint
  def edit
    begin
      @complaint = Complaint.find(params[:id])
    rescue
      redirect_to :root, notice: "Nice try, but next time you have to be smarter!"
    end 
  end

  # POST /complaints
  # POST /complaints.json
  #Action that enables the supplier to save the data inputed in the form as a new entrance in the database
  def create
    begin
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
    rescue
      redirect_to :root, notice: "Nice try, but next time you have to be smarter!"
    end 
  end

  # PUT /complaints/1
  # PUT /complaints/1.json
  #Action that enables the supplier to update the data inputed in the form in the respective entrance of the complaint database
  def update  
    begin
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
    rescue
      redirect_to :root, notice: "Nice try, but next time you have to be smarter!"
    end 
  end

#Author = Omar Aly
#Deletes a complaint by setting its deleted attribute to true
#Parameters(:id) which is the complaints id
  def updatedelete
    begin
      @complaint = Complaint.find(params[:id])
      @complaint.update_attributes(deleted: true)
      redirect_to supplier_complaints_url, :notice => "your complaint was successfully removed."
    rescue
      redirect_to :root, notice: "Nice try, but next time you have to be smarter!"
    end 
  end
end