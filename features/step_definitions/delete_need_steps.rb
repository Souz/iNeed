Given /^these needs with category "(.*?)" and customer "(.*?)":$/ do |category, customer, table|
  cat = Category.where(name: category.to_s)[0]
  cust = Customer.where(name: customer)[0]
  table.hashes.each do |att|
    need = Need.create!(name: att["name"], description: att["description"], category_name: att["category_name"])
    need.category = cat.id
    need.save
    need.customer = cust.id
    need.save
  end
end


