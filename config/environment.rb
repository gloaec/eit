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
