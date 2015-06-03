  Altijdheerlijk::Application.routes.draw do
  resources :pins do
    member do
      put "like", to: "pins#like"
      put "unlike", to: "pins#unlike"
    end
  end

  resources :pins do
  collection { post :import }
  end

  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }

  match '/users/:id/follow' => 'follows#create', :as => :user_follow, :via => [:post]
  match '/users/:id/unfollow' => 'follows#destroy', :as => :user_unfollow, :via => [:delete]

  resources :users 

  root "users#feeds"
  get "my_friends_pins" => "users#feeds"
  get "my_profile" => "users#my_profile"
  get "my_pins" => "pins#my_pins"
  get "upload" => "pins#upload"
  get "my_favorites" => "pins#my_favorites"
  get "my_friends" => "users#my_friends"
  get "followers" => "users#followers"
  get "search_pins" => "pins#index"
  get "search_by_location" => "users#feeds"
  get '/feeds' => 'users#feeds', :as => :feeds
  
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
