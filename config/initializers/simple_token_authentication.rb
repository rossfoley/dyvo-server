SimpleTokenAuthentication.configure do |config|
  config.sign_in_token = false
  config.header_names = { user: { authentication_token: 'X-User-Token', email: 'X-User-Username' } }  
end
