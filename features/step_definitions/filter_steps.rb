Given(/^the following needs exists?:?$/) do |table|
	table.hashes.map do |att|
		Need.create att
	end
end

Given(/^the following categories exists?:?$/) do |table|
	table.hashes.map do |att|
		Category.create att
	end
end

When /^I fill in the "(.*?)" with "(.*?)"$/ do |field, value|
  fill_in field, with: value
end

When /^I choose (.+) as the category$/ do |category|
  select category, from: 'category_name'
end

Then /^I should see a text field containing (.+?)$/ do |need|
  page.should have_content need
end

Then /^I shouldn't see a text field containing (.+?)$/ do |need|
  page.should_not have_content need
end

When /^I (?:click|press) (?:the\s)?"(.*?)" (button|link)$/ do |pressable, pressed_type|
  if pressed_type == 'link'
    click_link pressable
  else
    click_button pressable
  end
end

