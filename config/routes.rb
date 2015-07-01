Rails.application.routes.draw do
  resources :incomes, only: [:new, :create, :edit, :update, :destroy] do
    get 'search_between_dates', on: :collection 
    get 'all',                  on: :collection 
  end
  resources :expenses, only: [:new, :create, :edit, :update, :destroy]  do
    get 'search_between_dates', on: :collection 
    get 'all',                  on: :collection 
  end
  resources :users,           only: [:show, :new, :create, :edit, :update, :destroy]
  resource  :user_sessions,   only: [:create, :new, :destroy], path: '/auth'
  resource :confirmation,     only: [:show]
  resources :password_resets, only: [:new, :create, :edit, :update] 
  root 'home#index'
end
