#@Author: Yousra Hazem
class Supplier::CategoriesController < SupplierController  
  layout "supp_master"
  #@Author: Yousra Hazem  
  #@summary: Track is called from the Category view, on a certain category. If the category exists then it is added to the list of categories that this supplier tracks, if not then the suppler is notified. 
  def track
    begin
      @supplier = current_supplier
      @category = Category.find(params[:id])
      
      if ! @category.nil?
        @category.descendants_and_self.each do|category|
          @supplier.categories.push(category) 
        end   
        flash[:notice] = "Category is successfully tracked!"
        redirect_to :back
      else
        flash[:error] = "Sorry, this Category does not exist anymore..."
        redirect_to :back
      end
    rescue
      redirect_to :root, notice: "Nice try, but next time you have to be smarter!"
    end
  end

  #@Author: Yousra Hazem  
  #@summary: untrack is called from the Category view, on a certain category. If the category exists then it is removed from the list of categories that this supplier tracks, if not then the suppler is notified. 
  def untrack
    begin
      @category = Category.find(params[:id])    
      if ! @category.nil?
        @category.ancestors_and_self.each do |category|
          current_supplier.categories.delete(category)
        end
        flash[:notice] = "Category is successfully untracked..."
        redirect_to :back
      else
        flash[:error] = "Sorry, this Category does not exist anymore..."
        redirect_to :back
      end
    rescue
      redirect_to :root, notice: "Nice try, but next time you have to be smarter!"
    end    
  end
  #@Author: Yousra Hazem  
  #@summary: 
  #@Author: Yousra Hazem  
  #@summary: shows category's page. it provides it with the category's children and decides if the category is a leaf(i.e.has no subCategories and has subNeeds instead). If it has subNeeds, then action show prepares the subNeeds for the view to use them
  #@paramName: id => Category id 

  def show
    begin
      @category = Category.find(params[:id])
      @message = params[:message]
      @tracked = current_supplier.categories
      @children = @category.children
    rescue
      redirect_to :root, notice: "Nice try, but next time you have to be smarter!"
    end
  end

end
