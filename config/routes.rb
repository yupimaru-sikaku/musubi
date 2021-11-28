Rails.application.routes.draw do

  resources :cards
  root to: 'homes#index'
  
  # エンドユーザー
  devise_for :users, controllers: {
    sessions:      'users/sessions',
    passwords:     'users/passwords',
    registrations: 'users/registrations'
  }

  devise_scope :user do
    post 'users/sign_up/confirm', to: 'users/registrations#confirm'
    get 'users/sign_up/complete', to: 'users/registrations#complete'
  end
  
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
  }

  devise_scope :company do
    post 'companies/sign_up/confirm', to: 'companies/registrations#confirm'
    get 'companies/sign_up/complete', to: 'companies/registrations#complete'
  end

  resources :companies, only: [:show] do
    collection do
      get 'point_index'
      get 'terms'
      get 'explain_agency'
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
  # 代理店招待（代理店を設立したい方へ招待コードを送る）
  post 'homes/send_invitation_email', to: 'homes#send_invitation_email'
  # ユーザー招待（商品を購入したい方へ代理店コードを発行する）
  post 'homes/send_user_invitation_email', to: 'homes#send_user_invitation_email'

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
      post 'confirm'
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
