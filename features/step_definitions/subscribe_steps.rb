When /^there is an offer$/ do
  @offer = Offer.new
  @offer.save
end

Then /^I can click subscribe$/ do
  @transaction = Transaction.new
  @transaction.pending = false
  @transaction.quantity = 2
  @offer.num_of_subscribed_quantity = @offer.num_of_subscribed_quantity + 2
  @offer.save
  @transaction.save
end