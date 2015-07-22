Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => "registrations/registrations"}
  resources :incomes, only: [:new, :create, :edit, :update, :destroy] do
    get 'search_between_dates', on: :collection 
    get 'all',                  on: :collection 
  end
  resources :expenses, only: [:new, :create, :edit, :update, :destroy]  do
    get 'search_between_dates', on: :collection 
    get 'all',                  on: :collection 
  end
  root 'home#index'
end
