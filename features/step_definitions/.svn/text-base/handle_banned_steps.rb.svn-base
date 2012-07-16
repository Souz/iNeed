Given /^the following offers exist:$/ do |table|
  table.hashes.map do |att|
    Offer.create att
  end
end

Given /^the following transactions exist:$/ do |table|
  table.hashes.map do |att|
    Transaction.create att
  end
end

Then /^I should unneed "(.*?)" from the need "(.*?)"$/ do |arg1, arg2|
end

Then /^I should delete all comments of "(.*?)"$/ do |customer|
  Customer.where(name: customer)[0].comments.delete_all  
end

Then /^I should delete all the offers of "(.*?)"$/ do |supplier|
  Supplier.where(name: supplier)[0].offers.delete_all
end
