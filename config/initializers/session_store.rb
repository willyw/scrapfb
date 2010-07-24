# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_qt_session',
  :secret      => '1764ae491a0a513978db3f832c9d019af991f5826a1422a251ac671da65b6f3e5a9aeedaa0775ac48aa3e44113f9d169fcaa42a6ec708bfb822be8fa0a4317a5'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
