Rails.application.routes.draw do
  
  get 'companies/show'
  root to: 'services#index';

  # 病院・相談支援側
  devise_for :users, controllers: {
    sessions:      'users/sessions',
    passwords:     'users/passwords',
    registrations: 'users/registrations'
  }

  # 事業所側
  devise_for :companies, controllers: {
    sessions:      'companies/sessions',
    passwords:     'companies/passwords',
    registrations: 'companies/registrations'
  }

  resources :companies, only: [:show] do
    collection do
      get 'index_all'
    end
  end
  
  resource :services, only: [:index] do
    collection do
      get 'contact_done'
      get 'index_test'
    end
  end

  resources :fukushis, only: [:index] do
    collection do
      get 'contact'
      get 'contact_message'
    end
  end
  
  resources :iryos, only: [:new, :create, :index] do
    resource :favorites, only: [:create, :destroy]
    resources :favorites, only: [:index]
    collection do
      get 'contact'
      get 'contact_message'
    end
  end

  resources :ghs, only: [:index, :new, :create, :edit, :update, :destroy, :show] do
    collection do
      get 'ghs/downloadpdf/:id'=> 'ghs#downloadpdf' ,as: :donwload_pdf
    end
  end
  

end