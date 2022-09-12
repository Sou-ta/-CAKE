Rails.application.routes.draw do

  namespace :admin do
    get 'order_details/update'
  end
# 顧客用

  devise_for :customers, skip: [:passwords], controllers: {
  registrations: "public/registrations",
  sessions: 'public/sessions'
}

 scope module: :public do
    resources :customers, except: [:destroy]
    get '/' => 'homes#top'
    get '/about' => 'homes#about'
    resources :genres, only: [:show]
    patch 'out' => 'customers#out'
    get 'show' => 'customers#show'
    get 'customers/edit' => 'customers#edit'
    patch 'update' => 'customers#update'
    get 'quit' => 'customers#quit'
    get 'customers/quit'
    resources :items, only: [:index, :show]
    resources :cart_items, except: [:edit, :new, :show]
    delete 'destroy_all' => 'cart_items#destroy_all'
    post 'orders/comp'
    get 'orders/thanx'
    resources :orders, except: [:destroy, :edit]
    resources :addresses, except: [:new, :show]
  end




# 管理者用

  devise_for :admin, skip: [:registrations, :passwords], controllers: {
  sessions: "admin/sessions"
}

  namespace :admin do
   root to: 'homes#top'
   resources :customers, only: [:index, :edit, :update, :show]
   resources :genres, only: [:index, :create, :edit, :update]
   resources :items, only: [:show, :index, :new, :create, :edit, :update]
   resources :orders, only: [:index, :show, :update]
   resources :order_details, only: [:update]
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
