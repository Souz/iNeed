class RegistrationsController < Devise::RegistrationsController

  #@Author: Mohamed Diaa
      #@summary: action overridden from devise default registration controller for validating
      #         user before save, asking for more info if missing
      #@ParamName: "session[:omniauth]" : session controller carrying data from the provider for regisertaion
      #@ParamName: "@authentication" : is the account that is meant to be unlinked from iNeed account
  def create
    super
    if session[:omniauth]
      if  @customer.valid?
           # in the session his user id and the service id used for signing in is stored
           @customer.authentications.create!(:provider => session[:omniauth]['provider'], :uid => session[:omniauth]['uid'])
          flash[:notice] = 'Your account has been created and you have been signed in!'
        else
          flash[:error] = 'This is embarrassing! There was an error while creating your account from which we were not able to recover.'
        end 
        #clears the session after registration
        session[:omniauth] = nil unless @customer.new_record?
      end
  end
  
  private
  #@Author: Mohamed Diaa
      #@summary: action for building resources, where the data gets saved if the customer data is valid
      #         user before save, asking for more info if missing
      #@ParamName: "session[:omniauth]" : session controller carrying data from the provider for regisertaion
    def build_resource(*args)
      super
      if session[:omniauth]
        @customer.apply_omniauth(session[:omniauth])
        @customer.valid?
      end
    end
end