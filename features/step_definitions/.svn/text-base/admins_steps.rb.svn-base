
Given /^I am in the admins view$/ do  
  visit '/admins'
end


Then /^I should see a label called Admins and a table$/ do
  page.should have_css('h1', text: 'Admins')
  page.should have_css('table')
  page.should have_content 'alaa.shafaee92@gmail.com'
  page.should have_css "table.table.table-striped#admins tr", :count => 3
end

Then /^I should see the names and emails of admins$/ do
  page.should have_content 'alaa.shafaee92@gmail.com'
  page.should have_content 'nadanasreldin@gmail.com'
  page.should have_content 'dalia.william@gmail.com'
  page.should have_content 'Alaa'
end

Given /^ some admins have names$/ do
 Admin.where(email: 'alaa.shafaee92@gmail.com')
end

Given /^email "(.*?)" belongs to "(.*?)"$/ do |email, name|
   Admin.where(email: email).first.name = name
end

Given /^"(.*?)" is SuperAdmin$/ do |email|
  Admin.where(email: email).first.isSuperAdmin = true
end

Then /^I should not see delete buttons$/ do
  page.should_not have_button('Delete')
end

Then /^I should see delete button next to each admin except me$/ do
  page.should have_button('Delete')
end

Then /^I should (not )?see an element "([^"]*)"$/ do |negate, selector|
  expectation = negate ? :should_not : :should
  page.send(expectation, have_css(selector))
end
