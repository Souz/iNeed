# @Author = Dalia William
# @Author = Nada Nasr
#@Author = Mohamed Osama
class Admin::SuppliersController < AdminsController

  #@author: Dalia William, Nada Nasr
  #@summary: It creates 2 lists, "registered_suppliers" that gets all the registered suppliers(approved and not banned)
  #          and "unregistered_suppliers" that gets all the unregistered suppliers
  def index
    @registered_suppliers = Supplier.registered_not_banned.paginate :order=>'created_at desc', :per_page=>10, :page => params[:registered_suppliers]
    @unregistered_suppliers = Supplier.unregistered.paginate :order=>'created_at desc', :per_page=>10, :page => params[:unregistered_suppliers]
  end

  # @Author: Nada Nasr
  # @Summary: approves the supplier and redirects back to same page
  # @paramName: params[:supplier_id] => the id of the supplier to be approved
  def approve
    Admin.find(current_admin.id).approve_supplier(params[:supplier_id])
    redirect_to :action => 'index', :tab => 'unregistered'
  end

  # @Author: Nada Nasr
  # @Summary: rejects the supplier and redirects back to same page
  # @paramName: params[:supplier_id] => the id of the supplier to be rejected
  def reject
    Admin.find(current_admin.id).reject_supplier(params[:supplier_id])
    redirect_to :action => 'index', :tab => 'unregistered'
  end
  
  #@author: Dalia William
  #@summary: It calls warn_suppliers action (which is in Supplier model) than redirects to the registere suppliers page
  #@paramName: params[:reason] => reason enterred by the admin while warning
  #@paramName: params[:user_ids] => list of supplier ids chosen by the admin
  def warn 
    @reason_for_warning = params[:reason]
    @suppliers = params[:user_ids]
    Admin.find(current_admin.id).warn_suppliers(@suppliers, @reason_for_warning)
    redirect_to :action => 'index', :tab => 'registered'
   end
  #@author = Mohamed Osama
#@summary = takes the suppliers marked by the admin and loop on them unbanning each one of them
  def un_ban_marked_supplier
    #@banned_marked_suppliers = []
    @banned_marked_suppliers = Supplier.find(params[:user_ids])
    #@banned_marked_suppliers.map{|s| s.update_attribute(:banned,nil)}
    for supplier_id in params[:user_ids]
      (Supplier.find(supplier_id)).update_attribute(:banned, nil)
    end
    redirect_to :action => 'index', :tab => 'registered'
  end

  #@Author: Tarek Mehrez
  #@Summary: This action gets the checked suppliers then calls ban_marked_customers on current 
  #@paramName: :user_ids -> checked suppliers by the admin 
  #@paramName: :reason -> reason for banning supplier
  def ban
    Admin.find(current_admin.id).ban_marked_suppliers(params[:user_ids],params[:reason])
    redirect_to :action => 'index'
  end
end
