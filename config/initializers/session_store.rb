# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_new_cal_session',
  :secret      => '9120e5ab9c25a79e0abeb711625ce9f3ed5a46263f7540431c497dcb91dc1126ffe0a80b000b6ba5987ff065e64e969cba9ffcab559d70b8e92d00124cbb4792'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
