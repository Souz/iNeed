#@Author= Alaa Shafaee
#@Author = Mohamed Osama
class Admin::CategoriesController < AdminsController
  #@author = Mohamed Osama, Alaa Shafaee
  #@summary = creating a list called @categories having all the categories 
  def index
    Category.create_or_find_category('Others')
    @category = Category.new_category
    @categories = Category.list_categories
  end

  #@Author: Alaa Shafaee
  #@summary: creates a category with the name and parent passed in the hash "params".
             #A success notice is passed in case the category is added. Otherwise, 
             #validation errors will appear in the view.
  #@paramName: "parent_name" => contains the name of the parent category the admin selected
                                # which is saved in params[:category][:parent].
  def create
    params_category = params[:category]
    parent_name = params_category[:parent]
    @category = Category.add_category(parent_name, params[:category])
    respond_to do |format|
      if  @category.save
	    format.html { redirect_to admin_categories_path, notice: 'The category was successfully added.' }
        format.json { render json: @category, status: :created, location: @category }
      else
        @categories = Category.list_categories
        format.html { render controller: "categories" , action: "index"}
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end
  
  #@Author: Alaa Shafaee
  #@summary: destroys the category whose delete button is clicked in the view as well as all its descendants.
  #          Depending on the choice the admin selects in the view, either all needs belonging to this category
  #          are deleted or moved to category "others". Offers of deleted needs are deleted and users get updates.
  #@paramName: params[:id] => id of the category to be deleted
  #@paramName: categories_to_be_manipulated => array containing the category the admin selected together with its descendants.
  #@ParamName: params[:choice] => the number of radio button the user selected(1 or 2).
  def destroy
    categories_to_be_manipulated = Category.categories_in_tree(params[:id])
    needs_ids = []
    categories_to_be_manipulated.map { |category| needs_ids << Category.get_need_ids_from_category(category.id)}

    if(params[:choice] == "1")
      if(!needs_ids.nil?)
        needs_ids.each{ |need| Need.delete_reported_needs(need)}
      end
    elsif(Category.category_has_needs?(params[:id]))
      others = Category.create_or_find_category('Others')
      categories_to_be_manipulated.map { |category| Category.transfer_needs_to_category(category.id, others.id)}
    end
    
    respond_to do |format|
      if  Category.destroy_category(params[:id])
	format.html { redirect_to admin_categories_path, notice: 'The category was successfully deleted.' }
      else
        format.html { render controller: "admin_categories", action: "index"}
      end
    end  
   end
end
