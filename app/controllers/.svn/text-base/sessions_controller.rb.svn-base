class SessionsController < ApplicationController
 
# This controller dedicated to do auto auth to login through facebook
# This controller verfiy if the customer login before so it auto login, if not it allows regestration
 def create
  @newuser = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(uath)
  session[:user_id] = User.id
  redirect_to root_url, :notice => "signed in!"
 end


 def auth_hash
  request.env['omniauth.auth']
 end


 def destroy
  session[:user_id] = nil
  redirect_to root_url, :notice => "signed out!"
 end
 def index 
  @Users =User.all
 end
end

