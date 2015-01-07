Rails.application.routes.draw do
  resources :cats do
    resources :cat_rental_requests, only: [:index]
  end

  resources :cat_rental_requests, only: [:edit, :create, :new, :show, :update, :destroy] do
    member do
      post "approve"
      post "deny"
    end
  end

  root 'cats#index'
end
