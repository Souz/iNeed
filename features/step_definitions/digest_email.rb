Given /^I login to gmail with username "(.*?)" and password "(.*?)"$/ do |username,password|

	visit("mail.google.com/mail/sign_in")
	fill_in 'email', :with => username
	fill_in 'Passwd', :with => password
	click_button('signIn')
	click_link('Email')
end

And /^I open email message with subject "(.*?)"$/ do |subject|
	30.times do
	break if look_for_email_subject(subject)
		sleep(1)
		click_link('Inbox')
	end
	click_link(subject)
end


And /^I should see in email message "(.*?)"$/ do |regexp|
	regexp = Regexp.new(regexp)
	with_scope("table/tbody/tr[4]/td/div[@class='msg']") do
		if page.respond_to? :should
			page.should have_xpath('//', :text => regexp)
		else
			assert page.has_xpath?('//*', :text => regexp)
		end
	end
end

Then /^I clear my inbox$/ do
	Capybara.app_host = 'http://www.google.com'
	visit('/a/quickleft.com')
	click_link('Email')
	with_scope(nil) do
		page.all(:xpath, "//input[@type='checkbox']").each do |checkbox|
			checkbox.set(true)
		end
	end
	click_button('Delete')
end


def look_for_email_subject(subject)
	with_scope(nil) do
		page.has_link?(subject)
	end
end

Then /^I should receive digest email$/ do
  @email = ActionMailer::Base.deliveries.first
  @email.from.should == "iNeed <ineed.tester2@gmail.com>"
  @email.to.should == "essam <ma7ma7.2011@gmail.com>"
  @email.body.should include("offers")
end