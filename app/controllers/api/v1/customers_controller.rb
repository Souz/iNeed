class Api::V1::CustomersController < Api::V1::BaseController
#@Author: Mohamed Diaa
  #@Summary: All the following are the CRUD actions of the Customer's class
  #          Responding with Json along with the http response status 
  #@ParamName: 

  before_filter :check_banned, :only => [:index, :show, :edit, :update, :destroy, :customer_profile]
  before_filter :is_logged
  before_filter :restrict_access, :except => :create
  
  def check_banned
    unless not_banned?
      respond_with :status => :unprocessable_entity 
    end
  end

  def not_banned?
    if(current_customer)
      !(current_customer.banned)
    end
  end

  def is_logged
    current_customer
  end

  def index
    @customers = Customer.all
    respond_with @customers, :status => :ok
  end

  def show
    @customer = Customer.find(params[:id])
    respond_with @customer 
  end

  def new
    @customer = Customer.new
  end

  def edit
    @customer = Customer.find(params[:id])
  end

  def create
    @customer = Customer.new(params[:customer])
      if @customer.save
        respond_with @customer, :status => :created
      else
        respond_with @customer.errors, :status => :unprocessable_entity 
      end
  end

  def update
    @customer = Customer.find(params[:id])
      if @customer.update_attributes(params[:customer])
        respond_with  @customer,  :status => :ok
      else
        respond_with @customer.errors, :status => :unprocessable_entity 
      end
  end

  def destroy
    @customer = Customer.find(params[:id])
    @customer.destroy
    respond_with head :no_content 
  end


  def customer_profile
    @customer = customer.find(current_customer.id)
  end
end
