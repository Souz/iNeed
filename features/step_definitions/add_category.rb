def find_path(page_name)
  case page_name.downcase.strip

  when 'categories', 'categories '
    'localhost:3000/admin/categories'
  end
end


Given /^I am on "([^"]*)"$/ do |path|
  visit path
end

Given /^I am in the categories view$/ do  
  visit '/admin/categories'
end

Then /^I should see (?:a|an) "(.*?)" button$/ do |button|

  page.should have_css('submit', text: 'Add Category')
end

Then /^I should see labels and headers for the adding a category$/ do
  page.should have_css('h1', text: 'Categories')
  page.should have_css('h1', text: 'Add a Category')
  page.should have_css('label', text: 'Category name')
  page.should have_css('label', text: 'Parent category')
end

Then /^I should see a dropdown for selecting the parent category$/ do
  page.should have_css('select', minimum: 1)
end


Then /^I should see (.+?) active in the sidebar menu$/ do |menu_item|
  page.should have_css ('ul')
end

When /^I fill in "(.*?)" with "(.*?)"$/ do |arg1, arg2|
  fill_in arg1, :with => arg2
end

Given /^I have certain number of Categories$/ do
  @categories_count = Category.count
end

Then /^I should see the new category added$/ do
  Category.count.should == @categories_count + 1   
end

Then /^I should see a flash message saying "(.*?)"$/ do |message|
  page.should have_content message
end

When /^I select "(.*?)" as "(.*?)"$/ do |arg1, arg2|
  select arg1, from: arg2
end

Then /^I should see select fields for the parent category$/ do
  page.should have_css('select', minimum: 1)
end

Then /^the number of categories should be "([0-9]+)" because catgeory others is inserted by default$/ do |count|
  Category.count.should == count.to_i
end

Then /^there should be a category called "(.*?)" with parent "(.*?)"$/ do |child, parent|
  parent_category = Category.any_of({ name: parent }).first
  child_category = Category.any_of({ name: child }).first
  parent_category.id.should == child_category.parent_id
end

Then /^"(.*?)" has 1 child$/ do |parent_category_name|
  Category.any_of({ name: parent_category_name }).first.children.count.should == 1
end

#When /^I click (?:the\s)?(.+)\s(button|link)$/ do |link_name, button_type|
#  if pressed_type == 'link'
#    click_link link_name
#  else
#    click_button button_type
#  end
#end

