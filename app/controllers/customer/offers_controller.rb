#Author Mohamed Ayman
class Customer::OffersController < CustomerController
  # GET /customer/offers
  # GET /customer/offers.json
  def index
    @customer_offers = Customer::Offer.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @customer_offers }
    end
  end

  # GET /customer/offers/1
  # GET /customer/offers/1.json
  def show
    @customer_offer = Customer::Offer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @customer_offer }
    end
  end

  # GET /customer/offers/new
  # GET /customer/offers/new.json
  def new
    @customer_offer = Customer::Offer.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @customer_offer }
    end
  end

  # GET /customer/offers/1/edit
  def edit
    @customer_offer = Customer::Offer.find(params[:id])
  end

  # POST /customer/offers
  # POST /customer/offers.json
  def create
    @customer_offer = Customer::Offer.new(params[:customer_offer])

    respond_to do |format|
      if @customer_offer.save
        format.html { redirect_to @customer_offer, notice: 'Offer was successfully created.' }
        format.json { render json: @customer_offer, status: :created, location: @customer_offer }
      else
        format.html { render action: "new" }
        format.json { render json: @customer_offer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /customer/offers/1
  # PUT /customer/offers/1.json
  def update
    @customer_offer = Customer::Offer.find(params[:id])

    respond_to do |format|
      if @customer_offer.update_attributes(params[:customer_offer])
        format.html { redirect_to @customer_offer, notice: 'Offer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @customer_offer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customer/offers/1
  # DELETE /customer/offers/1.json
  def destroy
    @customer_offer = Customer::Offer.find(params[:id])
    @customer_offer.destroy

    respond_to do |format|
      format.html { redirect_to customer_offers_url }
      format.json { head :no_content }
    end
  end
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
  def subscribe
    @quantity = params[:quantity].to_i
    @offer_id = params[:offer_id]
    @offer = Offer.find(@offer_id)
    @offers = @offer.need.offers
    @need = @offer.need
    @offerlist = @need.offers.desc(:num_of_subscribed_quantity) #List of Offers of that Need
    @offerlist = @offerlist.map{|offer| Offer.find(offer.id)}
    @offerlist = @offerlist.keep_if{|offer| !offer.deleted}
    numberofoffers = @offerlist.size #no of offers for this need.

    if ( !@offerlist.empty? )&&( ((@offerlist[0]).num_of_subscribed_quantity * 1.0) != 0 )

      sum = 0 #init all quantity subscribed to all offers = 0
      list = []  #init empty list to be passed to the chart

      if numberofoffers > 4

        #loop to get first 5 subscipers on all offers on that need.
        for i in 0..4
          sum += ((@offerlist[i]).num_of_subscribed_quantity * 1.0)
        end

        #make a list if lists to be passed to the chart
        for i in 0..4
          supp = Supplier.find(@offerlist[i].supplier_id)
          list << [supp.email, ( @offerlist[i].num_of_subscribed_quantity * 1.0 ) ]
        end
      else
        #loop to get all number of subscipers on all offers on that need.
        @offerlist.each do |offer|
          sum += ((offer).num_of_subscribed_quantity * 1.0)
        end

        #make a list if lists to be passed to the chart
        @offerlist.each do |offer|
          supp = Supplier.find(offer.supplier_id)
          list << [supp.email, ( offer.num_of_subscribed_quantity * 1.0 ) ]
        end

      end
       @chart = LazyHighCharts::HighChart.new('pie') do |f|
          f.chart({:defaultSeriesType=>"pie"} )
          series = {
                   :type=> 'pie',
                   :name=> 'Offers Share',
                   :allowPointSelect=> true,
                   :data=> list
          }
          f.series(series)
          f.options[:title][:text] = "Share Of subscribers"
          f.legend(:layout=> 'vertical',:style=> {:left=> 'auto', :bottom=> 'auto',:right=> 'auto',:top=> 'auto'}) 
          f.plot_options(:pie=>{
            :allowPointSelect=>true, 
            :cursor=>"pointer" , 
            :dataLabels=>{
              :enabled=>true,
              :color=>"white",
              :style=>{
                :font=>"13px Trebuchet MS, Verdana, sans-serif"
              }
            }
          })
      end
      end
    if @quantity <= 0
      flash[:notice] = "Quantity must be an Integer and greater than 0"
    elsif (@quantity + @offer.num_of_subscribed_quantity) > @offer.quantity
      flash[:notice] = "The total quantity will be exceeding the maximum quantity of the offer"  
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
          flash[:notice] = "Subscription completed successfully"
      else
          flash[:notice] = "Please try again"
      end
    end
    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end

  #@author: Mohamed Ayman
  #@summary: A method that Customer use to unsubscribe a quantity less than or equal to his quantity of subscription,the method handles the cases of not typing any thing in the quantity field or typing a characters or negative numbers or a quantity greater than the subscription quantity
  #paramName : Params[:quantity] => the quantity entered by the user
  #paramName : Params[:offer_id] => the subscribed Offer id
  #paramName : Params[:trans] => array contain the transaction of the user and the offer
  def unsubscribe
    #@customer = Customer.find(current_customer.id)
    @quantity = params[:quantity].to_i
    @offer_id = params[:offer_id]
    @offer = Offer.find(@offer_id)
    #@subscriber = @customer.is_subscribed(current_customer.id, @offer_id)
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
  end
  
end
