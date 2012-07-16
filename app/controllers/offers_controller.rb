class OffersController < ApplicationController
#@Author: Nourhan Aloush
layout 'supp_master'  
before_filter :authenticate_supplier!
  # GET /offers/1
  # GET /offers/1.json
  #@Author: Nourhan Aloush
  #@Summary: this shows the summary page after submitting the offer
  def show
    begin
      @offer = Offer.find(params[:id])
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @offer }
      end
    rescue
      redirect_to :root, notice: "Nice try, but next time you have to be smarter!"
    end
  end

  # GET /offers/new
  # GET /offers/new.json
  #@Author: Nourhan Aloush
  #@Summary: It creates new offer with the parameters entered
  def new
    begin
      @offer = Offer.new
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @offer }
        format.js
      end
    rescue
      redirect_to :back, notice: "Invalid date !"
    end
  end

  # GET /offers/1/edit
  #This method is called in the summary page
  #@Author: Nourhan Aloush
  #@Summary: it calls by default update
  # => it returns to the form with the info written to edit them
  def edit
    begin
      @offer = Offer.find(params[:id])
    rescue
      redirect_to :back, notice: "Invalid date !"
    end
  end

  # POST /offers
  # POST /offers.json
  #@Author: Nourhan Aloush
  #@Summary: It is called after new is called
  # => It takes the values from params to create new offer
  # => it takes the supplier id from the session and need it from the session, 
  # => need_id is saved in the start of the form
  def create
    begin
      @offer = Offer.new(params[:offer])
      @offer.supplier = Supplier.find(current_supplier.id)
     	@offer.need = Need.find(params[:need_id])

  	respond_to do |format|
        if @offer.save
          if (!@offer.quantity_error)
            flash[:notice] = "The min quantity can't be more than the quantity itself, it has been automatically set to quantity !"
          end
          format.html { redirect_to @offer }
          format.json { render json: @offer, status: :created, location: @offer }
        else
          format.html { render action: "new" , :need_id => params[:need_id]}
          format.json { render json: @offer.errors, status: :unprocessable_entity }
        end
      end
    rescue
      redirect_to :back, notice: "Invalid date !"
    end
    
  end

  # PUT /offers/1
  # PUT /offers/1.json
  #@Author: Nourhan Aloush
  #@Summary: This is called when edit is called by user in summary page
  # => it updates the attributes with new values entered
  def update
    begin
      @offer = Offer.find(params[:id])
  	
      respond_to do |format|
        if @offer.update_attributes(params[:offer])
          if(@offer.published)
          	@offer.update_attribute(:expired, false)
            format.html { redirect_to supplier_offers_path, notice: 'Offer was successfully updated.' }
            format.json { head :no_content }
          else
            format.html { redirect_to @offer, notice: 'Offer was successfully updated.' }
            format.json { head :no_content }
          end
        else
          format.html { render action: "edit" }
          format.json { render json: @offer.errors, status: :unprocessable_entity }
        end
      end
    rescue
      redirect_to :back, notice: "Invalid date !"
    end
  end


  def destroy
    begin
      @offer = Offer.find(params[:id])
      @offer.update_attributes(deleted: 'true')
      Update.create(type: 'offer-c-d', offer_id: @offer.id)
      redirect_to supplier_offers_url
    rescue
      redirect_to :root, notice: "Nice try, but next time you have to be smarter!"
    end 
  end

end