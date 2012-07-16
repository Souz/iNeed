Given(/^the following comments exists?:?$/) do |table|
	table.hashes.map do |att|
		Comment.create att
	end
end

Then /^I choose 'Hate_Speech'$/ do
  choose('report')
end