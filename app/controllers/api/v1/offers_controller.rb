class Api::V1::OffersController < Api::V1::BaseController
  respond_to :json
  before_filter :restrict_access
  def index
    respond_with Offer.all
  end

  def show
    respond_with Offer.find(params[:id])
  end

# Author: Karim Tharwat
# Summary: the following method is the Api to the subscribe method
# Author: karim Tharwat
# Summary: this method subscribes the customer to an offer with the quantity he wants to subscribes with
# it does the follwing by checking if there exists a transaction for that customer to that offer, if there is it increases the quantity
# if there isn't it creates a new transaction saves it.
# after finishing one of the previous 2 steps it increases the quantity of the people subscribe to the offer and decreases the number of Needs.
# Parameters: 
#   @quantity: quantity retrieved from view
#   @offer_id: offer id retrieved from view
#   @offer: the offer of the previous id
#   @need_id: the need id retrieved from view
#   @expired: a boolean to get if the offer is expired from the view
#   @transaction: looks of there is a transaction in the database with the customer id and the offer id
#                 if there is it increments its quantity if there is not it creates one with default quantity of 0 
#                 then increments it with the wanted quantity.
# Note: i used the update attribute for the date because i created a method in the model and it kept creating errors
#       this is the API story for the subscribe
  def subscribe
    @quantity = params[:quantity].to_i
    @offer_id = params[:offer_id]
    @offer = Offer.find(@offer_id)
    if @quantity <= 0
      redirect_to :back, :notice => "Quantity must be greater than 0"
    elsif (@quantity + @offer.num_of_subscribed_quantity) > @offer.quantity
      redirect_to :back, :notice => "The total quantity will be exceeding the maximum quantity of the offer"  
    else  
      @need_id = params[:need_id]
      @expired = params[:offer_expired]
      @transaction = Transaction.find_or_create_by(customer_id: current_customer.id, offer_id: @offer_id)
      @transaction.increment_quantity(@quantity)
      if @expired
        @transaction.pending = true
      else
        @transaction.pending = false
      end
      if @transaction.save
          @offer.update_attribute(:last_modified, Date.today)
          @offer.increment_quantity(@quantity)
          redirect_to :back, :notice => "Subscription completed successfully"
      else
          redirect_to :back, :notice => "Please try again"
      end
    end
    respond_with Need.find(@need_id)
  end
  
  #@author: Mohamed Ayman
  #@summary: A method that Customer use to unsubscribe a quantity less than or equal to his quantity of subscription through the API.
  def unsubscribe
    @quantity = params[:quantity].to_i
    @offer_id = params[:offer_id]
    @offer = Offer.find(@offer_id)
    trans = Transaction.where(:customer_id => current_customer.id,:offer_id => @offer_id)
    if trans.empty?
      redirect_to :back, :notice => "Sorry you are not subscribed to this offer"
    elsif @quantity <= 0
      redirect_to :back, :notice => "Quantity must be an integer greater than 0"
    elsif @quantity > trans[0].quantity
      redirect_to :back, :notice => "The unsubscribed quantity must be less than or equal the Subscribed quantity"
    elsif (@offer.num_of_subscribed_quantity - @quantity) < 0
      redirect_to :back, :notice => "The total quantity can't be less than 0"
    elsif @quantity < trans[0].quantity
      @transaction = trans[0]
      @offer.update_attribute(:last_modified, Date.today)
      @offer.update_attribute(:num_of_subscribed_quantity, @offer.num_of_subscribed_quantity - @quantity)
      @transaction.update_attribute(:quantity, @transaction.quantity - @quantity)
      redirect_to :back, :notice => "Unsubscription completed successfully"
    elsif @quantity == @transaction.quantity
      @transaction = trans[0]
      @offer.update_attribute(:last_modified, Date.today)
      @offer.update_attribute(:num_of_subscribed_quantity, @offer.num_of_subscribed_quantity - @quantity)
      @transaction.destroy
      redirect_to :back, :notice => "Unsubscription completed successfully ,you are not in this offer anymore"
    else
      redirect_to :back, :notice => "Please try again"
    end
    respond_with Need.find(@need_id)
  end
end