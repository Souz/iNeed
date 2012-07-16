#@Author = Tarek Mehrez
#@Author = Nada Nasr
class Admin::UsersController < AdminsController

  # @Author: Nada Nasr
  # @Summary: used by admin. redirects to admin's default mailing account with emails of marked suppliers in the "to" field
  # @paramName: params[:user_ids] => list of user ids whom the admin wants to email
  def mailto_users
      mailto_string = User.mailto_string(params[:user_ids])
      redirect_to mailto_string
  end

  #@Author: Tarek Mehrez
  #@summary: get all banned customer & suppliers pass them to the view in seperate objects
  def banned
    @banned_suppliers = Supplier.where(banned: true).paginate :order=>'created_at desc', :per_page=>10, :page => params[:banned_suppliers]
    @banned_customers = Customer.where(banned: true).paginate :order=>'created_at desc', :per_page=>10, :page => params[:banned_customers ]
    

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @banned_customers }
      format.json { render :json => @banned_suppliers }
    end


  def un_ban_marked_user
    @tab = ''
    for user_id in params[:user_ids]
      if(User.find(user_id)._type == "Customer")
        Customer.find(user_id).unban
        @tab = 'table'
      else
        Supplier.find(user_id).unban
        @tab = 'suppliers'
      end
    end
    redirect_to :action => 'banned', :tab => @tab
  end

  end
end
