Rails.application.routes.draw do
  root to: 'welcome#index'
  resources :merchants, only: %i[show index] do
    resources :dashboard, only: [:index]
    resources :items, except: [:destroy]
    resources :item_status, only: [:update]
    resources :invoices, only: %i[index show update]
  end

  namespace :admin do
    resources :dashboard, only: [:index]
    resources :merchants, except: [:destroy]
    resources :merchant_status, only: [:update]
    resources :invoices, except: %i[new destroy]
  end
end
