#Author = Omar Aly
#Author = Nourhan Aloush
#Author = Mirna ElBendary
class Supplier::OffersController < SupplierController

 layout 'supp_master'

#@Author: Nourhan Aloush
#@Summary: This method is called in the summary page 
# => It changes the boolean published to true to be showed in the need's page and my offers page
  def publish
    begin
      @offer = Offer.find(params[:offer_id])
      @need = Need.find(params[:need_id])
      @offer.update_attributes(published: 'true')
      Update.create(type: 'need-c', need_id: params[:need_id]) 
      @needers = @need.customers
      @needers.each do |needer|
        	UserMailer.subscribed_email(needer, @need).deliver
      end
      redirect_to supplier_offers_path, notice: 'Offer was successfully published!'
    rescue
      redirect_to :root, notice: "Nice try, but next time you have to be smarter!"
    end
  end
  
  
  #Author = Mirna ElBendary
  #summary =  it activates a certain offer on a certain need. so we check, if the minimum 
  #quantity of needs is less than or equal to the total number of subscribed needs. if so we check
  #if it was already activated. if not then the offer is activated and customers get updated.
  
   def activate  
    begin
      @offer = Offer.find(params[:id])
      if(@offer.num_of_subscribed_quantity >= @offer.min_quantity)
        if (@offer.activated == true)
          redirect_to supplier_offers_url, notice: 'Sorry, offer already activated!'
        else 
          @offer.update_attribute(:activated, 'true')
          Update.create(type: 'offer-c-a', offer_id: params[:id]) 
          @transactions = Transaction.where(offer_id: params[:id])
          @transactions.each do |trans|
          	UserMailer.activation_email_customer(trans.customer, @offer).deliver
          end
          redirect_to supplier_offers_url, notice: 'Offer successfully activated!'
        end
      end
    rescue
      redirect_to :root, notice: "Nice try, but next time you have to be smarter!"
    end
   end
#Author = Omar Aly
#Index Page for Offers - Supplier/Offers
#Fetches all of the offers of the current logged in supplier that are not deleted
#Checks if any offers are expired, automatically updates their status
  def index
    begin
      @Offers = Offer.where(supplier_id: current_supplier.id, deleted: false).paginate(:per_page => 10, :page=> params[:page])
      @Offers.each do |offer|
        if offer.expiry_date < Date.today
          offer.update_attributes(expired: true)
        end
      end
    rescue
      redirect_to :root, notice: "Nice try, but next time you have to be smarter!"
    end
  end

#Author = Omar Aly
#Delete Action for Offers
#Changes deleted attribute to true
#Parameters (:offer_id)
  def updatedelete
    begin
      @offer = Offer.find(params[:offer_id])
      @offer.update_attributes(:deleted => true)
      Update.create(type: 'offer-c-d', offer_id: @offer.id)
      @transactions = Transaction.where(offer_id: params[:offer_id])
      @transactions.each do |transaction|
        transaction.update_attributes(deleted: true)
        UserMailer.deleted_offer_email(transaction.customer, @offer).deliver
      end
      redirect_to supplier_offers_url, notice: 'Offer was successfuly deleted!'
    rescue
      redirect_to :root, notice: "Nice try, but next time you have to be smarter!"
    end
  end

#Author = Omar Aly
#Update Date Action, used to extend the expiry date
#Not Actually used throughout the implementation
#Parameters (:offer_id, :date)
  def updatedate
    begin
      if params[:date].nil?
        redirect_to supplier_offers_url
      else
        @offer = Offer.find(params[:offer_id])
        @offer.update_attributes(expired: 'false', expiry_date: params[:date])
        redirect_to supplier_offers_url
      end
    end
    rescue
      redirect_to :root, notice: "Nice try, but next time you have to be smarter!"
    end
end