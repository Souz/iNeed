class Admin::CustomersController < AdminsController
#@Author = Mohamed Osama
#@summary = takes the cutomers marked by the admin and loop on them unbanning each one of them
  def un_ban_marked_customer
      $banned_marked_customers = []
      $banned_marked_customers = params[:user_ids]
      for customer_id in $banned_marked_customers
        (Customer.find(customer_id)).update_attribute(:banned, nil)
      end
      redirect_to :action => 'banned'
  end

end
