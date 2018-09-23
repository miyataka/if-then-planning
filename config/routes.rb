Rails.application.routes.draw do
    root to: 'home#index'

    namespace :api do
        namespace :v1, format: 'json' do
            resources :event, only: [:index, :create]
            resources :tasks, only: [:index, :create, :update, :destroy]
        end
    end
end
