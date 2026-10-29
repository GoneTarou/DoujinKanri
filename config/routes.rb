Rails.application.routes.draw do
  get "home/index"
  get "up" => "rails/health#show", as: :rails_health_check

  devise_for :users, skip: :all
  resource :guest_session, only: :create
  resources :works, only: [ :index, :new, :create, :show, :edit, :update, :destroy ] do
    resources :work_processes, only: [ :create, :destroy ]

    resource :availability_setup, only: [ :new, :create ]
    resources :weekly_availabilities, only: [ :index, :edit, :update ]
  end
  resources :process_checks, only: :update
  root "home#index"
end
