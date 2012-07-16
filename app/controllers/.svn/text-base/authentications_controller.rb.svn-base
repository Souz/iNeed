class AuthenticationsController < ApplicationController
  
  #before_filter :authenticate_customer!,:except => [:create]
  
   #layout 'cust_master'
  
  #@Author: Mohamed Diaa
    #@summary: action for showing all authentications
    #@ParamName: "current_customer" : is the logged_in customer at the moment
    #@ParamName: "@authentications" : shows all accounts linked to the current_customer
  def index
    @authentications = current_customer.authentications if current_customer
  end

  #@Author: Mohamed Diaa
    #@summary: action linking accounts to the iNeed Account
    #@ParamName: "current_customer" : is the logged_in customer at the moment
    #@ParamName: "@authentications" : shows all accounts linked to the current_customer
    #@ParamName: "omniauth" : is the data from provider call back
    #@ParamName: ":provider" : is the social network we are connecting to
  def create
    omniauth = request.env["omniauth.auth"]
    authentication =  Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if authentication
      flash[:notice] = "Signed in successfully."
       sign_in_and_redirect(:customer, authentication.customer)
    elsif current_customer
      current_customer.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'])
      flash[:notice] = "Authentication successful."
       redirect_to authentications_url
    else
      customer = Customer.new
      customer.apply_omniauth(omniauth)
      if customer.save
        flash[:notice] = "Signed in successfully."
         sign_in_and_redirect(:customer, customer)
      else
        session[:omniauth] = omniauth.except('extra')
         redirect_to new_customer_registration_url
      end
    end
  end

  #@Author: Mohamed Diaa
    #@summary: action unlinking accounts from the iNeed Account
    #@ParamName: "current_customer" : is the logged_in customer at the moment
    #@ParamName: "@authentication" : is the account that is meant to be unlinked from iNeed account
  def destroy
    @authentication = current_customer.authentications.find(params[:id])
    @authentication.delete
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to authentications_url
  end
end
