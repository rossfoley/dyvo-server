class Api::BaseController < BaseController
  acts_as_token_authentication_handler_for User, except: [:cors_preflight_check], fallback_to_devise: false
  before_filter :ensure_logged_in, except: [:cors_preflight_check]

  private

  def ensure_logged_in
    failure(:unauthorized, 'You must provide a user email and authentication token') unless user_signed_in?
  end
end
