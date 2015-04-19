Rails.application.routes.draw do
  match '*path' => 'application#cors_preflight_check', via: :options, constraints: {method: 'OPTIONS'}
  devise_for :users
  
  namespace :api do
    scope 'facebook' do
      post 'login' => 'facebook#login'
      get 'callback' => 'facebook#verify_callback'
      post 'callback' => 'facebook#handle_callback'
    end

    scope 'users/(:id)', constraints: {id: /\d+/} do
      get 'friends' => 'users#friends'
      get 'refresh_friends' => 'users#refresh_friends'
      get 'vobs' => 'users#vobs'
    end

    resources :vobs, except: [:new, :edit] do
      collection do
        get 'within'
      end
    end
  end
end
