#@author: Nourhan Azab
class HomeController < ApplicationController
  # GET /homes
  # GET /homes.json
  layout 'home_master'
  #@author: Nourhan Azab
  #@summary: this action is used to render the homepage for customers and suppliers
  def index
    if !current_customer.nil?
      redirect_to my_needs_customer_needs_path,notice: 'You are already logged in!'
    else 
        if !current_supplier.nil?
          redirect_to supplier_offers_path,notice: 'You are already logged in!'
        else
          respond_to do |format|
            format.html # index.html.erb
            format.json { render json: @homes }
          end
        end
    end
  end
  
end