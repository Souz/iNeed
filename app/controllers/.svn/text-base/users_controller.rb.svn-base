class UsersController < ApplicationController
	
#When You are adding the Register Action, just add:

# UserMailer.registration_confirmation(@user).deliver

#to call the registration_confirmation method in the UserMailer mailer,
#and You can find it's view with the Same Name in the views folder for the UserMailer, It have its description
#"Hazem Tawfik"

#the following method(change_password) begins by getting the user by his id
#then checking if the coming request is a HTTP POST
#then it checks if the string entered in the old_password field is the same as the one in the database,
#if it is and the string entered in the new_password field and its confirmation are the same,
#then it changes the password and flashes a notice to tell user of the success of the method else it flashes an error

	def change_password

		@user = User.find(params[:id])

		if request.post?
		if User.authenticate(@user.username,
		params[:password][:old_password]) == @user
		@user.password = params[:password][:new_password]
		@user.password_confirmation =
		params[:password][:new_password_confirmation]
		if @user.save
		flash[:notice] = 'Your password has been changed'
		else
		flash[:error] = 'Unable to change your password'
		end
		else
		flash[:error] = 'Invalid password'
		end
		end
		end 
end
