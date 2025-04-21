Rails.application.routes.draw do
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  scope :api do
    resources :list, path: 'my_list', only: [:index, :create]

    resources :items, path: 'my_items', only: [:create, :destroy] do
      member do
        post :start
        post :complete
      end
    end

    namespace :admin do 
      resources :list,  only: [:index, :show, :create, :destroy] do
        resources :items, only: [:show, :create, :destroy] do
          member do
            post :start
            post :complete
          end
        end
      end
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

end
