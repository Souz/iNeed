
When /^I click the "(.*?)" link within "(.*?)"$/ do |link, selector|
    page.should have_css('table.table.table-striped#table')
end

Given /^I delete "(.*?)" category$/ do |arg1|
  
end

Given /^I choose "(.*?)"$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

Given /^I try$/ do |arg1|
  
end

Then /^the catgeory should be deleted$/ do
  pending # express the regexp above with the code you wish you had
end

Given /^I choose 'Delete all related needs'$/ do
  choose('choice_1')
end

Given /^I choose 'transfer needs to category others'$/ do
  choose('choice_2')
end

Then /^the number of needs should be "([0-9]+)"$/ do |count|
  Need.count.should == count.to_i
end
