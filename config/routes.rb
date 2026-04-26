Rails.application.routes.draw do
  get 'otp/new'
  get 'otp/verify'
  get 'tenant_dashboard/index'
  devise_for :users, controllers: {
  registrations: "users/registrations",
  sessions: "users/sessions"
}

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  root "home#index"
  get "dashboard", to: "dashboard#index"

  get "otp", to: "otp#new"
  post "otp/verify", to: "otp#verify"


  namespace :v1 do
    resources :tenants
    resources :units
    resources :leases
  
    resources :payments do
      collection do
        post :create_order
        post :verify
      end
    end
  end


end



