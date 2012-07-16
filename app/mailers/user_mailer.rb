#@Author= Hazem El-Kilisly

class UserMailer < ActionMailer::Base
  default :from => "iNeed <ineed.tester4@gmail.com>"

#@Author= Hazem El-Kilisly
#@summary= This email is sent to customers,suppliers after their account being accepted by the admin.
#@paramName= User => The receiver.
  def approve_email(user)
    @user = user
    email_with_name = "#{@user.name} <#{@user.email}>"
    mail(:to => email_with_name, :subject => "Approval Email")  
  end

#@Author= Hazem El-Kilisly
#@summary= This email is sent to customers,suppliers after their account being rejected by the admin
#@paramName= User => The receiver.
  def reject_email(user)
    @user = user
    email_with_name = "#{@user.name} <#{@user.email}>"
    mail(:to => email_with_name, :subject => "Rejection Email")  
  end

#@Author= Hazem El-Kilisly
#@summary= This email is sent to customers,suppliers after being banned by the admin.
#@paramName= User => The receiver.
  def banning_mail(user)
    @user = user
    email_with_name = "#{@user.name} <#{@user.email}>"
    mail(:to => email_with_name, :subject => "Ban Email")
  end

#@Author= Hazem El-Kilisly
#@summary= This it the Digest Email Method used to link that particular Method to it's corresponding E-Mail view to be sent.
#@paramName= User => The receiver.
  def digest_mail(user)
    @user = user
    @url = "ineed.pagekite.me"
    @hot_needs = Need.order_by_numberOfoffers
    email_with_name = "#{@user.name} <#{@user.email}>"
    mail(:to => email_with_name, :subject => "Our Hot Needs")
  end




#@Author= Nourhan Aloush
#@Summary= The activation email of the customer
# => it sends an email if the offer which this customer is subscribed to is activated
#@ParamName= "user" => the user itself, in this case it will be a customer
#@ParamName= "offer" => The offer object, which has been activated
  def activation_email_customer(user, offer)
    @user = user
    @offer = offer
    email_with_name = "#{@user.name} <#{@user.email}>"
    mail(:to => email_with_name, :subject => "Activated offer")  
  end

#@Author= Nourhan Aloush
#@Summary= The subscribed email of the customer
# => it sends an email if the need which this supplier needed has a new offer
#@ParamName= "user" => the user itself, in this case it will be a customer
#@ParamName= "offer" => The need object, which has new offer
  def subscribed_email(user, need)
    @user = user
    @need = need
    email_with_name = "#{@user.name} <#{@user.email}>"
    mail(:to => email_with_name, :subject => "new offer")  
  end

#@Author= Nourhan Aloush
#@Summary= The deleted offer notification email
# => it sends an email if the offer which this customer is subscribed to is deleted
#@ParamName= "user" => the user itself, in this case it will be a customer
#@ParamName= "offer" => The offer object, which has been deleted
  def deleted_offer_email(user, offer)
    @user = user
    @offer = offer
    email_with_name = "#{@user.name} <#{@user.email}>"
    mail(:to => email_with_name, :subject => "Deleted offer")  
  end


#@Author= Nourhan Aloush
#@Summary= The expired email of the supplier
# => it sends an email if any offer of the supplier's offers is expired
#@ParamName= "user" => the user itself, in this case it will be a supplier
#@ParamName= "offer" => The offer object, which has been expired
  def expired_email(user, offer)
    @user = user
    @offer = offer
    email_with_name = "#{@user.name} <#{@user.email}>"
    mail(:to => email_with_name, :subject => "Expired offer")  
  end

#@Author= Nourhan Aloush
#@Summary= The expired email of the supplier
# => it sends an email if any offer of the supplier's offers is expired
#@ParamName= "user" => the user itself, in this case it will be a supplier
#@ParamName= "offer" => The offer object, which has been expired
  def deleted_offer_need_email(user, offer)
    @user = user
    @offer = offer
    email_with_name = "#{@user.name} <#{@user.email}>"
    mail(:to => email_with_name, :subject => "Deleted offer")  
  end

#@Author= Nourhan Aloush
#@Summary= The activation email of the supplier
# => it sends an email if the number of subcribers on an offer 
# => has reached the required number to activate
#@ParamName= "user" => the user itself, in this case it will be a supplier
#@ParamName= "offer" => The offer object
  def activation_email_supplier(user, offer)
    @user = user
    @offer = offer
    email_with_name = "#{@user.name} <#{@user.email}>"
    mail(:to => email_with_name, :subject => "Activate offer")  
  end

#@Author= Nourhan Aloush
#@Summary= The digest email of the supplier
# => it checks if something new has been updated in any of his offers
# => if yes, it will send a summry of these offers
#@ParamName= "user" => the user itself, in this case it will be a supplier
  def digest_email_supplier(user, offers)
    @user = user
    @offers = offers
    @url = "ineed.pagekite.me"
    email_with_name = "#{@user.name} <#{@user.email}>"
  	mail(:to => email_with_name, :subject => "Offers updates")  
  end

#@Author= Nourhan Aloush
#@Summary= The notification email of need for supplier
# => it sends an email if the number of needers on this need 
# => has reached the required number which the supplier asked for
#@ParamName= "user" => the user itself, in this case it will be a supplier
#@ParamName= "need" => The tracked need object
  def tracked_need_email(user, need)
    @user = user
    @need = need
    email_with_name = "#{@user.name} <#{@user.email}>"
    mail(:to => email_with_name, :subject => "Tracked need")  
  end

  def banned_supplier_email(supplier , customer)
    @customer = customer
    @supplier = supplier
    email_with_name = "#{@customer.name} <#{@customer.email}>"
    mail(:to => email_with_name, :subject => "Deleted Offer")  

  end

end  