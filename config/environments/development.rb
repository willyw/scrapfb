# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false




AppDetail= {
  :hostname => "http://localhost:3000",
  :name => 'qTiest-Dev'
}
API_KEY = 'e4de6a450580adedbdadf124fba63e11'
APP_SECRET = '3368a580517b3cc316c9293cf24619fc'
APP_ID  = '135319876508646'

HOST = "http://localhost:3000"