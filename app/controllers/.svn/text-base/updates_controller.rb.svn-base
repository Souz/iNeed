class UpdatesController < ApplicationController
  # GET /updates
  # GET /updates.json
  
  #the index page shows the updates of one user ( the id of the    logged user will be grabed from the session and passed to this method ).
 # i created the @needs array to contain the need ids of each update to be passed later to the view ( to view the picture ).
# user_id is just a variable  i pass it for now till i'd be able to get it from the logged in session
  layout :choose_layout
  def choose_layout  
    if current_supplier == nil
      return 'cust_master'
    else
      return 'supp_master'
    end
  end

  def index
    begin
    	@updates = []
    	if current_supplier.nil?
    		allUpdates = Update.all
    		allUpdates.each do |update|
    			if(update.customer_ids.include? current_customer.id)
    				@updates << update
    			end
    		end
    	else
    	 @updates = Update.where(supplier_id: current_supplier.id)
    	end

    rescue
      redirect_to :root, notice: "Nice try, but next time you have to be smarter!"
    end 
  end

  # GET /updates/1
  # GET /updates/1.json
  def show
    begin
      @update = Update.find(params[:id])

      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @update }
      end
    rescue
      redirect_to :root, notice: "Nice try, but next time you have to be smarter!"
    end 
  end

  # GET /updates/new
  # GET /updates/new.json
  def new
    begin
      @update = Update.new

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @update }
      end
    rescue
      redirect_to :root, notice: "Nice try, but next time you have to be smarter!"
    end 
  end

  # GET /updates/1/edit
  def edit
    begin    
      @update = Update.find(params[:id])
    rescue
      redirect_to :root, notice: "Nice try, but next time you have to be smarter!"
    end 
  end

  # POST /updates
  # POST /updates.json
  def create
    begin
      @update = Update.new(params[:update])

      respond_to do |format|
        if @update.save
          format.html { redirect_to @update, notice: 'Update was successfully created.' }
          format.json { render json: @update, status: :created, location: @update }
        else
          format.html { render action: "new" }
          format.json { render json: @update.errors, status: :unprocessable_entity }
        end
      end
    rescue
      redirect_to :root, notice: "Nice try, but next time you have to be smarter!"
    end 
  end

  # PUT /updates/1
  # PUT /updates/1.json
  def update
    begin
      @update = Update.find(params[:id])

      respond_to do |format|
        if @update.update_attributes(params[:update])
          format.html { redirect_to @update, notice: 'Update was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @update.errors, status: :unprocessable_entity }
        end
      end
    rescue
      redirect_to :root, notice: "Nice try, but next time you have to be smarter!"
    end 
  end

  # DELETE /updates/1
  # DELETE /updates/1.json
  def destroy
    begin
      @update = Update.find(params[:id])
      @update.destroy
      @updates = []
      if current_supplier.nil?
        allUpdates = Update.all
        allUpdates.each do |update|
          if(update.customer_ids.include? current_customer.id)
            @updates << update
          end
        end
      else
       @updates = Update.where(supplier_id: current_supplier.id)
      end

      respond_to do |format|
        format.html { redirect_to updates_url }
        format.json { head :no_content }
        format.js
      end
    rescue
      redirect_to :root, notice: "Nice try, but next time you have to be smarter!"
    end 
  end

  def list_all_updates
    begin
      return @updates = Update.all
    rescue
      redirect_to :root, notice: "Nice try, but next time you have to be smarter!"
    end 
  end


end
