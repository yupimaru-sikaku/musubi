Rails.application.routes.draw do

  resources :cards
  
  # エンドユーザー
  devise_for :users, controllers: {
    sessions:      'users/sessions',
    passwords:     'users/passwords',
    registrations: 'users/registrations'
  }
  resources :users, only: [:show] do
    collection do
      get 'purchase_histroy'
    end
  end
  
  # 代理店
  devise_for :companies, controllers: {
    sessions:      'companies/sessions',
    passwords:     'companies/passwords',
    registrations: 'companies/registrations',
    invitations: 'companies/invitations'
  }
  resources :companies, only: [:show] do
    collection do
      get 'point_index'
    end
  end

  # HPの画面
  root to: 'homes#index'
  resources :homes, only: [:index] do
    collection do
      get 'invitation'
    end
  end
  post 'homes/send_invitation_email', to: 'homes#send_invitation_email'

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

  # カード情報作成
  resources :cards, only: [:new, :create]

  # pdfの作成
  resources :post_pdf, only: :index
  
  get 'carts/show', to: 'carts#show', as: 'carts_show'
  get 'carts/session_reset', to: 'carts#session_reset'
  post 'carts/add_cart', to: 'carts#add_cart'
  patch 'carts/change_quantity', to: 'carts#change_quantity', as: 'change_item_quantity'
  delete 'carts/destroy_carts_item', to: 'carts#destroy_carts_item', as: 'destroy_carts_item'
  get '/perchase_completed/:id', to: 'orders#perchase_completed', as: 'perchase_completed'


end
