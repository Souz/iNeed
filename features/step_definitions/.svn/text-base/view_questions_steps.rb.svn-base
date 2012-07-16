Then /^I should see all questions$/ do
  page.should have_css('table')
  page.should have_content "Did you receive your product one time ?"
  page.should have_content "Did the supplier's services met your requirements?"

end

Given (/^questions with the following data:$/) do |table|
  table.hashes.map do |att|
    Question.create att
  end
end
