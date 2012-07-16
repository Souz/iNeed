Given /^I can see needs$/ do
  @needs = Need.all
end

When /^I create a need & go to its page/ do 
	@need = Need.new
end

Then /^I can click iNeed$/ do
    @need.total_needers = @need.total_needers+1
    current_customer = Customer.new
    @need.locate_needer(current_customer.location)
    if @need.save
      @need.customers.concat(current_customer)  
      current_customer.needs.concat(@need)
    end
end

