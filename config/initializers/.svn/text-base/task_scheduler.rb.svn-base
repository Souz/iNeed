#@Author= Hazem El-Kilisly
#@Author: Nourhan Aloush


require 'rubygems'
require 'rufus/scheduler'

scheduler = Rufus::Scheduler.start_new

#@Author: Hazem El-Kilisly
#@summary: It schedules Sending the Digest E-mail to Customer every certain Period of Time.

	scheduler.every '1d' do #every 5 minutes
	#scheduler.every '1d' do #every 1 day
	# every day of the week at 22:00 (10pm)
	#scheduler.cron '0 22 * * 1-5' do
	if(Need.count > 3)
		customers = Customer.all
		customers.each do |customer|
		  UserMailer.digest_mail(customer).deliver
		end
	end
	
end


#@Author: Nourhan Aloush	
#@summary: It periodically checks if there are any new updates for the suppliers
scheduler.every '1d' do
	@suppliers = Supplier.all
	@suppliers.each do |supplier|
		Update.check_updates(supplier.id)
	end
end


#@Author: Nourhan Aloush	
#@summary: It checks if there are any modifications in any offers for the supplier
# => if so, it sends him a digest email
scheduler.every '1d' do
	@suppliers = Supplier.all
	@modified_offers = []
	@suppliers.each do |supplier|
		@offers = Offer.where(supplier_id: supplier.id)
		modified = false
		@offers.each do |offer|
			if(offer.last_modified == Date.today)
				modified = true
				@modified_offers << offer
			end
		end
		if(modified)
			if(@modified_offers.count > 3)
				UserMailer.digest_email_supplier(supplier, @modified_offers).deliver
			end
		end
	end
end


#@Author: Nourhan Aloush	
#@summary: It periodically checks if there are any expired offers or offers ready to be activated 
# => to send emails to the supplier informing him
scheduler.every '1d' do 
	@offers = Offer.all
	@suppliers = Supplier.all
	@offers.each do |offer|
		if(offer.expiry_date < Date.today)
			offer.update_attribute(:expired, true)
			UserMailer.expired_email(offer.supplier, offer).deliver
		end
		if(offer.num_of_subscribed_quantity > offer.min_quantity && !offer.activated && !offer.deleted)
			UserMailer.activation_email_supplier(offer.supplier, offer).deliver		
		end
	end
end