Given (/^the following supplier exists:$/) do |table|
  table.hashes.map do |att|
    Supplier.create att
  end
end

Given /^needs with the following data:$/ do |data_table|
  Need.delete_all
  $needs_hash = {}
  data_table.hashes.each do |hash|
    @need1 = Need.create(:name => hash["name"])
    $needs_hash[hash["name"]] = @need1
  end
  data_table.hashes.each do |hash|
    @need3 = $needs_hash[hash["number_needers"]]
  end
end

Given /^I am in the hot needs view$/ do  
  visit '/supplier/needs/hot_needs_supplier'
end

