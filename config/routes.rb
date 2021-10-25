Rails.application.routes.draw do

  resources :cards
  root to: 'homes#index'
  
  # エンドユーザー
  devise_for :users, controllers: {
    sessions:      'users/sessions',
    passwords:     'users/passwords',
    registrations: 'users/registrations'
  }
  resources :users, only: [:show] do
    collection do
      get 'purchase_histroy'
      get 'card_terms'
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
      get 'terms'
    end
  end

  # HPの画面
  resources :homes, only: [:index] do
    collection do
      get 'invitation'
      get 'invitation_complete'
      get 'sdgs'
    end
  end
  post 'homes/send_invitation_email', to: 'homes#send_invitation_email'

  resources :products
  
  resources :orders do
    collection do
      get 'confirm'
    end
  end

  # カード情報作成
  resources :cards, only: [:new, :create]
  
  # お問い合わせ
  resources :contacts, only: [:new, :create] do
    collection do
      get 'contanct_complete'
    end
  end

  resources :pdfs do
    collection do
      get 'toggle_is_finished'
    end
  end
  
  get 'carts/show', to: 'carts#show', as: 'carts_show'
  get 'carts/session_reset', to: 'carts#session_reset'
  post 'carts/add_cart', to: 'carts#add_cart'
  patch 'carts/change_quantity', to: 'carts#change_quantity', as: 'change_item_quantity'
  delete 'carts/destroy_carts_item', to: 'carts#destroy_carts_item', as: 'destroy_carts_item'
  get '/perchase_completed/:id', to: 'orders#perchase_completed', as: 'perchase_completed'


end
