class CategoriesController < ApplicationController

  layout :choose_layout
  def choose_layout  
  if current_supplier == nil
    return 'cust_master'
  else
    return 'supp_master'
  end
  end

#Invoked when the admin wishes to add a category
#Initially a root category is created nammed "categories". 
def addCategory


	if(Category.all.count == 0)
		root = Category.create(name: "categories")
		root.parent = nil
	end
#@category, @categories are used by the vuew to display a list of categories (should be used by Mohamed)
	@categories = Category.all
	@category = Category.new
 render(:layout => "layouts/standard")
end


#-----------------------------------------------------------------------------------
#This action deletes a category using the id as well as deleting all children of this category.

  def destroy
    @category = Category.destroy_category(params[:id])
    redirect_to list_categories_path
  end

#--------------------------------------------------------------------------------------
#creates a new Category (i.e adds category) and sets its parent to be the category with the name selected by the Admin in the view
  def create
    # s1 contains the name of the parent category the admin selected which is saved in params[:category][:parent] (as specified in the view.)
    params_category = params[:category]
    category_name = params_category[:parent]
    #gets the first AND ONLY category with the name the admin selected (parent category).
    @category = Category.add_category(category_name, params[:category])
    #If the need is successfully added, a success notice will be passed. Else, validation errors will appear in the view. 
    #In both cases the Admin stays on the same page with the content updated to include the new category in case of success.
    respond_to do |format|
		  if	@category.save
			  format.html { redirect_to list_categories_path, notice: 'Need was successfully created.' }
        format.json { render json: @category, status: :created, location: @category }
      else
        format.html { render controller: "admins", action: "addCategory"}
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end
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
