class SuppliersController < ApplicationController

  def is_logged
    unless logged_in?
      flash[:error] = "You are not logged in you can't access this page"
      #redirect_to
    end
  end

  def logged_in?
    supplier_signed_in
  end
 
  def check_approval
    unless is_approved?
      flash[:error] = "You haven't been approved yet you can't access this page"
      #redirect_to
    end
  end

  def is_approved?
    !(current_supplier.approved)
  end
  def check_banned
    unless not_banned?
      flash[:error] = "You are banned you can't access this page"
      #redirect_to
    end
  end

  def not_banned?
    !(current_supplier.banned)
  end
#This controller is only viewed by the supplier so it takes the supp_master layout
   layout 'supp_master'
#RIP action is called by a supplier to view their deleted or their expired offers. The action first searches for the supplier using the attribute supplier_id from the session, then it queries in this supplier's offers. If there are no deleted or expired offers, then suppliers/noRIP view is rendered, otherwise it queries for those offers and passes them to the view: suppliers/RIP through the parameter @dead
  def RIP
    @supplier = Supplier.find(current_supplier.id)
    if @supplier.offers.find_all{|offer| offer.deleted == true or offer.expired == true}.count == 0
      render(template: 'suppliers/noRIP')
    else 
      @dead = @supplier.offers.find_all{|offer| offer.deleted == true or offer.expired == true}
      render(template: 'suppliers/RIP')
    end
  end
  
  
  #the following method gets the supplier variable to the view

  def supplier_profile
  @supplier = supplier.find(current_Supplier.id)
  end
  

  def show

  end

end
