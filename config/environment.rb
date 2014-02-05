# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
NrjEit::Application.initialize!

# Devise Layouts
NrjEit::Application.config.to_prepare do
    Devise::SessionsController.layout "devise"
    Devise::RegistrationsController.layout proc{ |controller| user_signed_in? ? "application"   : "devise" }
    Devise::ConfirmationsController.layout "devise"
    Devise::UnlocksController.layout "devise"            
    Devise::PasswordsController.layout "devise"        
end

# Configure Mails
ActionMailer::Base.delivery_method = :smtp
#ActionMailer::Base.default_content_type = "text/html"
ActionMailer::Base.smtp_settings = {
   :address => "smtp.gmail.com",
   :port => 587,
   :domain => "gmail.com",
   :authentication => :login,
   :user_name => "ghis182@gmail.com",
   :password => "Turtoise182",
   :enable_starttls_auto => true
}
