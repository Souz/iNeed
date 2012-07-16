class AccessController < ApplicationController
  def index
  	menu
  	render('menu')
  end

  def menu
  	# Display text and links
  end

  def login
  	# login form
  end

  def attempt_login
  	# if succeeded will go to menu if failed go to login
  	authorised_user = user.authenticate(params[:username], params[:password])
  	if authorised_user
  		# Mark user as logged in
  		flash[:notice] = "You are now logged in."
  		redirect_to(:action => 'menu')
  	else
  		flash[:notice] = "Invalid username/password combination."
  		redirect_to(:action => 'login')
  	end
  end
end
