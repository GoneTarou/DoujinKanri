Rails.application.routes.draw do
  get "home/index"
  get "up" => "rails/health#show", as: :rails_health_check

  devise_for :users, skip: :all
  resource :guest_session, only: :create
  resources :works, only: [ :index, :new, :create, :show, :edit, :update, :destroy ]
  root "home#index"
end
