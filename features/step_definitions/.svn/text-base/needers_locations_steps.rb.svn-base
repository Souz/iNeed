Given /^a category "(.*?)" with a need "(.*?)" with description "(.*?)"$/ do |category, need, need_description|
  Category.delete_all
  Need.delete_all
  cat = Category.create(name: category)
  need = Need.create(name: need, description: need_description, category_name: category)
  need.category = cat
  need.save
end
Then /^I should not see "(.*?)" written on the page$/ do |statement|
	page.should_not have_content statement
end
Then /^I should not see "(.*?)" in a button$/ do |button_name|
	page.should_not have_button button_name
end
