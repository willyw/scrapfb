# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.8' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|



  config.gem "authlogic"
  config.gem 'uuidtools'

  config.time_zone = 'UTC'


end

# ExceptionNotifier.sender_address = %("Application Error" <qtiest.dev@gmail.com>)
# ExceptionNotifier.exception_recipients = %w(w.yunnal@gmail.com)
# ExceptionNotifier.email_prefix = "[qTiest-Error] "

ExceptionNotification::Notifier.exception_recipients = %w(w.yunnal@gmail.com)
ExceptionNotification::Notifier.sender_address = %("Application Error" <qtiest.dev@gmail.com>)
ExceptionNotification::Notifier.email_prefix = "[qTiest-Error] "





