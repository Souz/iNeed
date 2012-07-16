#@Author= Alaa Shafaee
#@Author= Nourhan Azab
class Category
  include Mongoid::Document
  include Mongoid::Tree
# Tree is included to allow nesting the categories (i.e specifying the ancestors and descendants of each category)
  field :name, type:String
  has_many :needs
  has_and_belongs_to_many :suppliers

#validations (names must be non empty and unique)
validates_uniqueness_of :name, :case_sensitive => false , :message => "This category already exists"
validates_presence_of :name, :message => "Category name shouldn't be blank"

#@Author= Nourhan Azab
#@summary = gets a list of names of the leaf categories
#@paramname = @categories => leaf categories
#@paramname = category_names => a list of names of leaf categories
def self.get_leaf_categories
    @categories = Category.leaves
    category_names=[]
    @categories.map{|category| category_names << category.name}
    category_names
  end
  
  #@Author= Alaa Shafaee
  #@summary= adds a category with the specified name and parent in the hierarchy of categories.
             #The category is a root category in case no name for parent is specified.
  #@paramname= "Parent_name" => A string containing the name of the parent category.
  #@paramname= "category" => A string containing the name of the category to be added.
  
  def self.add_category(parent_name, category)
    if(parent_name.empty?)
       create_category(category[:name])
    else
	  parent = Category.any_of({ name: parent_name }).first
	  parent.children.new(category)
    end    
  end

  #@Author= Alaa Shafaee
  #@summary= deletes the category with the given id. This boolean method returns whether the action is completed.
  #@paramname= "category_id" => A string containing the id of the category to be deleted.
    
  def self.destroy_category(category_id)
    category = Category.find(category_id)
    category.delete_descendants
    category.delete   
  end

  def has_start(q)
    name = self.name.downcase.split
    name.each do |subname|
      if subname.start_with?(q)
        return true
      end
    end
    return false
  end

  #@Author= Alaa Shafaee
  #@summary= returns an array of all nodes in a category tree.
  #@paramname= "root_id" => The id of the root category in the tree.
  def self.get_need_ids_from_category(category_id)
    needs = Category.find(category_id).needs
    need_ids = []
    needs.map {|need| need_ids << need.id}
    need_ids
  end

  #@Author= Alaa Shafaee
  #@summary= checks whether the passed category has needs.
  #@paramname= "categoryId" => the id of the category to be tested
  def self.category_has_needs?(categoryId)
    !Need.where(category_id: categoryId).empty?
  end


  #@Author= Alaa Shafaee
  #@summary= returns an arry of all nodes in a category tree.
  #@paramname= "root_id" => The id of the root category in the tree.
  def self.categories_in_tree(root_id)
    Category.find(root_id).descendants << Category.find(root_id)
  end


  #@Author= Alaa Shafaee
  #@summary= deletes the needs of a given category by setting the attribute "deleted" to true (soft delete).
  #@paramname= "categoryId" => A string containing the id of the category whose needs are to be deleted.
  
  def self.delete_category_needs(categoryId)
    Need.where(category_id: categoryId).update_all(deleted: true)
  end

  #@Author= Alaa Shafaee
  #@summary= returns the category with the given name and creates one if not found.
  #@paramname= "category_name" => A string containing the name of the category to be created or found.
  
  def self.create_or_find_category(category_name)
    Category.find_or_create_by(name: category_name)
  end
  
  #@Author= Alaa Shafaee
  #@summary= transfers the needs of a given category to another category.
  #@paramname= "old_category_id" => A string containing the id of the category whose needs are to be transfered.
  #@paramname= "new_category_id" => A string containing the id of the category that will receive these needs.
  
  def self.transfer_needs_to_category(old_category_id, new_category_id)
    Need.where(category_id: old_category_id).update_all(category_id: new_category_id)
  end

  #@Author= Alaa Shafaee
  #@summary= Creates a new category with the given name.
    
  def self.create_category(category_name)
    Category.create(name: category_name)
  end

  #@Author= Alaa Shafaee
  #@summary= returns a list of all categories
  def self.list_categories
    Category.all
  end

  #@Author= Alaa Shafaee
  #@summary= returns a new category
  def self.new_category
    Category.new
  end
end
