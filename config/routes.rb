Rails.application.routes.draw do

  devise_for :users
  # HPの画面
  root to: 'homes#index'
  resources :homes, only: [:index]

  resources :products
  resource :services, only: [:index] do
    collection do
      get 'contact_done'
      get 'index_test'
    end
  end
  
  resources :orders do
    collection do
      get 'confirm'
    end
  end

  # pdfの作成
  resources :post_pdf, only: :index
  
  get 'carts/show', to: 'carts#show', as: 'carts_show'
  get 'carts/session_reset', to: 'carts#session_reset'
  post 'carts/add_cart', to: 'carts#add_cart'
  patch 'carts/change_quantity', to: 'carts#change_quantity', as: 'change_item_quantity'
  delete 'carts/destroy_carts_item', to: 'carts#destroy_carts_item', as: 'destroy_carts_item'
  get '/perchase_completed/:id', to: 'orders#perchase_completed', as: 'perchase_completed'


end
