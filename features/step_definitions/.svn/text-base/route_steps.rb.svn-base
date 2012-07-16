def find_path(page_name)
  case page_name.downcase.strip

  when 'home', 'home '
    '/'
  when 'filter','filter '
  	'/needs/filter'
  when 'needs', 'needs '
    '/needs'
  when 'customers sign in', 'customers sign in '
    '/customers/sign_in'
  when 'customer home', 'customer home '
    '/customer/needs/my_needs'
  when 'id', 'id '
  	'/customer/need/id'
  when 'questions', 'questions '
    '/admin/questions'
  end
end


Given /^I am on the (.+) page$/ do |page|
  steps %Q{When I go to #{page}}
end

When /^I go to (?:the\s)?(.+?)(?:\s?page)?$/ do |page|
  path = find_path(page)
  visit path
end

Then /^I visit the customer needs "(.*?)" page$/ do |name|
  id = (Need.where(name: name.to_s)[0]).id
  id = id.to_s
  path = '/customer/needs/'+id
  visit(path)
end

Then /^I should go to (?:the\s)?(.+?)(?:\s?page)?$/ do |page|
  path = find_path(page)
  current_path.should == path
end

