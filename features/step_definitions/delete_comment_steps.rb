Given /^the following comments with customer "(.*?)" and need "(.*?)":$/ do |customer, need, table|
  cust = Customer.where(name: customer)[0]
  need = Need.where(name: need)[0]
  table.hashes.each do |att|
  	comment = Comment.create!(content: att["content"], created_on: att["created_on"])
  	comment.need = need.id
  	comment.save
  	comment.customer = cust.id
  	comment.save
  end
end

Then /^I should not see comment content (.+?)$/ do |comment|
  page.should_not have_content comment
end