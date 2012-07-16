Then /^I should see a form$/ do
  page.should have_selector('form')
end

When /^I enter (.*?)$/ do |question|
  fill_in "question[content]", :with => question
end

Then /^I should see "(.*?)" on the page$/ do |statement|
  page.has_content?(statement)
end