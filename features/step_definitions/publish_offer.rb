Given /^the following user exists?:?$/ do |table|
	table.hashes.map do |att|
		@current_supplier = Supplier.create att
	end
end

Given /^the following category exists?:?$/ do |table|
	table.hashes.map do |att|
		Category.create att
	end
end

Given /^the following need exists?:?$/ do |table|
	table.hashes.map do |att|
		@need = Need.create att
	end
end

Given /^the following offer exists?:?$/ do |table|
	table.hashes.map do |att|
		@offer = Offer.create att
	end
	@offer.update_attribute(:need_id, @need.id)
	@offer.update_attribute(:supplier_id, @current_supplier.id)
end

Given /^I sign in as (.*?)$/ do |name|
  	@current_supplier.update_attribute(:approved, true)
    visit('/')
    fill_in "supplier[email]", with: @current_supplier.email
    fill_in "supplier[password]", with: @current_supplier.password
    select "Supplier", from: "type"
    click_button('Sign in')
end


When /^I click on the "(.*?)" button$/ do |button|
    click_button button
end

And /^I should see my offer published$/ do
	 page.should have_content 'Waiting for more subscribers'
end
