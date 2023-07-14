Rails.application.routes.draw do
  devise_for :users

  authenticated :user do
    root "categories#index", as: :authenticate_root
  end
 
  resources :categories, only: [:index, :new, :create] do
    resources :transactions
  end

  root "luncher#index"
end
