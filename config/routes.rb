Rails.application.routes.draw do
  root "home#show"

  resources :evaluation_requests, only: :create

  namespace :admin do
    root "training_clips#index"
    resource :session, only: [ :new, :create, :destroy ]
    resources :training_clips, except: :show
    resources :evaluation_requests, only: [ :index, :update ]
  end

  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
