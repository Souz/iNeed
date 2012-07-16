Given /^a logged in supplier$/ do
  $supplier  =  Supplier.create(name: 'yousra', email: 'yousrahazem@gmail.com', password: 'password')
  $supplier.update_attribute(:approved, true)
  visit('/suppliers/sign_in')
  fill_in('supplier_email', :with => $supplier.email)
  fill_in('supplier_password', :with => $supplier.password)
  click_button('Sign in')
  page.should have_content "iNeed"
end

Given /^categories with the following data:$/ do |data_table|
  Category.delete_all
  $categories_hash = {}
  data_table.hashes.each do |hash|
    @category1 = Category.create(:name => hash["name"])
    $categories_hash[hash["name"]] = @category1
  end
  data_table.hashes.each do |hash|
    @category3 = $categories_hash[hash["parent_name"]]
    if !@category3.nil?
      @category2 = $categories_hash[hash["name"]]
      @category3.children.push(@category2)
    end
  end
end

When /^I am on the page of "(.*?)" Category$/ do |category|
  category1 = $categories_hash[category]
  visit "/supplier/categories?id=#{category1.id}"
  #visit supplier_categories_path(@category.id)
  page.body.should have_content "Books"
end
When /^I click a link named "(.*?)"$/ do |link_name|
  click_button link_name
end

Then /^I should see "(.*?)" in a link$/ do |link_name|
  page.body.should have_link link_name
end

When /^I click a button named "(.*?)"$/ do |button_name|
  click_button button_name
end
Then /^I should see "(.*?)" in a button$/ do |button_name|
  page.should have_button button_name
end

Then /^I should not see "(.*?)" in a link$/ do |link_name|
  page.body.should_not have_link link_name
end
Then /^I should see "(.*?)" written on the page$/ do |statement|
  page.body.should have_content statement
end
