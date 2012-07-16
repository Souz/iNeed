#@Author: Yousra Hazem
class Customer::CategoriesController < CustomerController  
  layout "cust_master"
  def show
    begin
      @category = Category.find(params[:id])
      @cat_name  = @category.name
      @needs = @category.needs.keep_if{|n| !n.deleted}.paginate :page => params[:page],:per_page => 10
    rescue
      flash[:notice] = "Nice try, but next time you have to be smarter! ;D"
      redirect_to my_needs_customer_needs_path
    end
  end

end
