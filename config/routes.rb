Rails.application.routes.draw do
  root to: 'public/homes#top'
  
  # 管理者側
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }
  
  # 顧客側
  devise_for :costomers, skip: [:passwords], controllers: {
    registrations: "customer/registrations",
    sessions: 'customer/sessions'
  }
  
  scope module: :public do
    # homes
    get 'about' => 'homes#about'
    
    # items
    get 'items' => 'items#index'
    get 'items/:id' => 'items#show', as: 'items_show'
    
    # customers
    get 'customers/my_page' => 'customers#show', as: 'my_page'
    get 'customers/edit' => 'customers#edit', as: 'my_page_edit'
    patch 'customers' => 'customers#update', as: 'my_page_update'
    get 'customers/exit' => 'customers#exit', as: 'my_page_exit'
    patch 'customers/withdraw' => 'customers#withdraw', as: 'my_page_withdraw'

    # cart_items
    delete 'cart_items/destroy_all' => 'cart_items#destroy_all', as: 'cart_all_delete'
    resources :cart_items, only: [:index, :update, :destroy, :create]

    # address
    resources :addresses, only: [:index, :edit, :create, :update, :destroy]

    # orders
    post 'orders/confirm' => 'orders#confirm', as: 'orders_confirm'
    get 'orders/thanks' => 'orders#thanks', as: 'orders_thanks'
    resources :orders, only: [:index, :new, :create, :show]
  end

  # admin
  namespace :admin do
    get '' => 'homes#top', as: 'top'
    resources :customers, only: [:index, :show, :edit, :update]
    resources :genres, only: [:index, :create, :edit, :update]
    resources :items, except: [:destroy]
    # 商品検索用
    get 'search' => 'items#search', as: 'search'
    resources :orders, only: [:show, :update]
  end
end
