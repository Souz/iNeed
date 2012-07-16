Given (/^the following customers exists:$/) do |table|
  table.hashes.map do |att|
    Customer.create att
  end
end

Given(/^I have the following categories:$/) do |table|
  table.hashes.each do |att|
    Category.create!(name: att["name"])
  end
end

Given /^the following needs exists with category "(.*?)":$/ do |category, table|
  cat = Category.where(name: category.to_s)[0]
  table.hashes.each do |att|
    need = Need.create!(name: att["name"], description: att["description"], category_name: att["category_name"])
    need.category = cat.id
    need.save
  end
end


Then /^I can fill the "(.*?)" with "(.*?)"$/ do |field, value|
  fill_in field, with: value
end

Then /^it should say "(.*?)"$/ do |statement|
  page.should have_content statement
end