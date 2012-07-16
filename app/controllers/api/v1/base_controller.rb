class Api::V1::BaseController < ApplicationController
  #@Author = Mohamed Diaa
  #@summary:The Base controller is the main controller of the API, 
  #          all other  API classes inherit from it
  respond_to :json

  #@Author: Mohamed Diaa
  #@summary: checking if the token (hidden in the http header) exists or not.
  private
  def restrict_access
    authenticate_or_request_with_http_token do |token, options|
      Key.exists?(access_token: token)
    end
  end 
end