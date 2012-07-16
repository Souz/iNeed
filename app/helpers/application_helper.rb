#@Author: Yousra Hazem
#@Author:Mohamed Osama
module ApplicationHelper
  #@Author: Yousra Hazem
  #@summary: This action is used to generate an unsorted list of categories dynamically to the supplier's master page to be displayed in the side menu. It starts by the Category roots and then for each category, it finds its subcategories in a depth first manner by passing it to find_all_subcategories
  def display_categories
     @categories = Category.roots
	   ret = "<ul>"
	   @categories.each do |category|
			  ret += "<li>"
		  ret += link_to category.name, :controller => "supplier/categories", :action => "show", :id => category.id    
		  ret += find_all_subcategories(category, 1)
		  ret += "</li>"
	   end
	   ret += "</ul>"
      ret.html_safe
  end
    
  def find_all_subcategories(category, level)
    ret = '<ul>'
      category.children.each do |subcat| 
        if !subcat.leaf?()
          ret += '<li>'
          ret += link_to subcat.name, :controller => "supplier/categories", :action => "show", :id => subcat.id    
          ret += find_all_subcategories(subcat, (level + 1))
          ret += '</li>'
        else
          ret += '<li>'
          ret += link_to subcat.name, :controller => "supplier/categories", :action => "show", :id => subcat.id     
          ret += '</li>'
        end
      end 
      ret += '</ul>'
      #ret += button_to 'Delete', admin_category_path(category), :method => 'delete', :confirm => 'Are you sure?', :category_id => category.id
  end
  #@Author: Mohamed Ossama
  #@Author: Alaa Shafaee
  #summary: The buttons change the id of the common pop up form according to the selected category.
  def show_category(category)
    @categories = Category.roots
    ret = '<ul>'
    ret += '<table>'
    #ret += '<table border="1">'
    ret += '<tr>'
    ret += '<td>'
    ret += category.name
    ret += spaces
    if(category.name != 'Others')
      ret += '<td>'
      ret += '<a class="btn-small btn-primary" data-toggle="modal" href="#myModal" ' 
      ret += 'onclick="document.getElementById(\'id\').value = \''+ category.id.to_s+'\';"'
      ret += '>'
      ret += 'delete </a>'

      ret += '</td>'
      ret += '</tr>'
    end
    ret += '</table>'
    ret += find_subcategories(category, 1)

    
    ret += '</li>'
    ret += '</ul>'
    ret.html_safe
  end

  #@Author: Mohamed Ossama
  #@Author: Alaa Shafaee
  #summary: The buttons change the id of the common pop up form according to the selected category.  
  def find_subcategories(category, level)
    ret = '<ul>'
    category.children.each do |subcat| 
      if !subcat.leaf?()
        ret += '<table>'
        ret += '<tr>'
        ret += '<td>'
        ret += subcat.name
        ret += '</td>'
        ret += spaces
        ret += '<td>'
      ret += '<a class="btn-small btn-primary" data-toggle="modal" href="#myModal" ' 
      ret += 'onclick="document.getElementById(\'id\').value = \''+ subcat.id.to_s+'\';"'
      ret += '>'
      ret += 'delete </a>'
        ret += '</td>'
        ret += '</tr>'
        ret += '</table>'
        ret += find_subcategories(subcat, (level + 1))
      else
        ret += '<table>'
        ret += '<tr>'
        ret += '<td>'
        ret += subcat.name
        ret += '</td>'
        ret += spaces
        ret += '<td>'
      ret += '<a class="btn-small btn-primary" data-toggle="modal" href="#myModal" ' 
      ret += 'onclick="document.getElementById(\'id\').value = \''+ subcat.id.to_s+'\';"'
      ret += '>'
      ret += 'delete </a>'
        ret += '</td>'
        ret += '</tr>'
        ret += '</table>' 
      end
    end    
    ret += '</ul>'
      #ret += button_to 'Delete', admin_category_path(category), :method => 'delete', :confirm => 'Are you sure?', :category_id => category.id
  end
  def spaces
    ret = '<ul>'
    ret += '<td>'
    ret += '</td>'
    ret += '<td>'
    ret += '</td>'
    ret += '<td>'
    ret += '</td>'
    ret += '<td>'
    ret += '</td>'
    ret += '<td>'
    ret += '</td>'
    ret += '<td>'
    ret += '</td>'
    ret += '<td>'
    ret += '</td>'
    ret += '<td>'
    ret += '</td>'
    ret += '<td>'
    ret += '</td>'
    ret += '</ul>'
    return ret
  end
end

