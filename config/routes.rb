Rails.application.routes.draw do
  get "home/index"
  get "up" => "rails/health#show", as: :rails_health_check

  devise_for :users, skip: :all
  resource :guest_session, only: :create

  root "home#index"
end
