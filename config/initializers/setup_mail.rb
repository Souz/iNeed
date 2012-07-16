#@Author: Hazem El-Kilisly
#@summary: The Settings for the E-mail Server

ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :user_name            => "ineed.tester4",
  :password             => "ineed.com",
  :authentication       => "plain",
  :enable_starttls_auto => true
}

ActionMailer::Base.default_url_options[:host] = "localhost:3000"