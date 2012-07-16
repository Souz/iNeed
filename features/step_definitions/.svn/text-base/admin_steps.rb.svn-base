Given /^users with the following data:$/ do |data_table|

  $users_hash = {}

  data_table.hashes.each do |hash|

    if hash["type"] == "admin"
      admin = Admin.create(email: hash["email"], password: hash["password"])
      admin.update_attribute(:name, hash["name"])
      $users_hash[hash["name"]] = admin

    elsif hash["type"] == "supplier"
      supplier = Supplier.create(email: hash["email"], password: hash["password"])
      supplier.update_attribute(:name, hash["name"])
      $users_hash[hash["name"]] = supplier

    else
      customer = Customer.create(email: hash["email"], password: hash["password"])
      customer.update_attribute(:name, hash["name"])
      $users_hash[hash["name"]] = customer
    end

  end
end

Given /^that (.*?) has been approved$/ do |supplier|
  $users_hash[supplier].update_attribute(:approved, true)
end

Given /^I am logged in as (.*?)$/ do |name|
  $current_user = $users_hash[name]
  if $current_user._type == "Admin"
    visit('/admins/sign_in')
    fill_in "admin[email]", with: $current_user.email
    fill_in "admin[password]", with: $current_user.password
    click_button('Log in')
  elsif $current_user._type == "Supplier"
    visit('/')
    fill_in "supplier[email]", with: $current_user.email
    fill_in "supplier[password]", with: $current_user.password
    click_button('Sign in')
  else
    visit('/')
    fill_in "customer[email]", with: $current_user.email
    fill_in "customer[password]", with: $current_user.password
    click_button('Sign in')
  end
end
