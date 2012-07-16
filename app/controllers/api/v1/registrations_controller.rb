class Api::V1::RegistrationsController < Api::V1::BaseController
  respond_to :json
  before_filter :restrict_access, :only => :destroy
  #@Author: Mohamed Diaa
    #@summary: action for connecting to the creating account, or logging in.
      # New users should provide: name, email, password, location.
      # After a key is given to them.
    #@ParamName: "params[:customer]" : is a customer data passed to the API
    #@ParamName: "Key": is access_token that acts as a password for the customer (through API)
  def create
    if Customer.find(:email => params[:customer.email])
      authenticate_or_request_with_http_token do |token, options|
        if Key.exists?(access_token: token)
          key = Key.find_by_access_token(token)
        end
      end
      if key
        unless Customer.find(params[:customer.id]).keys.include? key
          key = Key.new
          customer.keys.push(key)
        end
        sign_in(params[:customer])
        respond_with :status => :ok
      end
    else
      customer = Customer.new(params[:customer])
      key = Key.new
      customer.keys.push(key)
      if customer.save!
        respond_with :status=> :created
      else
        warden.custom_failure!
        respond_with customer.errors, :status=> :unprocessable_entity
      end
    end  
  end

  #@Author: Mohamed Diaa
    #@summary: action for unlinking account from the api, but the customer stays in the database
    #@ParamName: "Key": is access_token that acts as a password for the customer (through API)
  def destroy
    @key = current_customer.keys.find(params[:id])
    @key.delete
    respond_with :status => :no_content
  end

end