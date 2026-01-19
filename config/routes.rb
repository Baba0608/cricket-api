Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post "/signup", to: "auth#signup"
      post "/login",  to: "auth#login"
      delete "/logout", to: "auth#logout"
      get "/me", to: "auth#me"

      resources :users
      resources :players, except: [ :index ] do
        collection do
          get :profile
          get :search
        end
        member do
          get :friends
          get :friend_requests
          get :team
        end
      end
      resources :teams, only: [ :create, :update ] do
        resources :match_invites, only: [ :index, :create ], module: :teams
      end

      resources :match_invites, only: [] do
        member do
          post :accept
          post :reject
        end
      end

      resources :matches, except: [ :create ] do
        member do
          post :invite_player
        end
      end

      resources :friendships, only: [ :create ] do
        member do
          post :accept
          post :reject
        end
      end
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
