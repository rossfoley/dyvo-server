Rails.application.routes.draw do
  match '*path' => 'application#cors_preflight_check', via: :options, constraints: {method: 'OPTIONS'}
  devise_for :users
  
  namespace :api do
    post 'facebook/login' => 'facebook#login'
    get 'facebook/callback' => 'facebook#verify_callback'
    post 'facebook/callback' => 'facebook#handle_callback'

    scope 'users/(:id)', constraints: {id: /\d+/} do
      get 'friends' => 'users#friends'
      get 'vobs' => 'users#vobs'
    end

    scope 'vobs' do
      get '/' => 'vobs#index'
      get 'within' => 'vobs#within'
    end
  end
end
