Rails.application.routes.draw do
  root 'home#main'
  get '/index' => 'home#index'
  get '/recipients' => 'home#recipients'
  get '/peers' => 'home#peers'
  get '/additional_peers' => 'home#additional_peers'
  get '/terms' => 'home#terms'
  get '/privacy' => 'home#privacy'
  get '/data' => 'home#data'
  get 'help' => 'home#help'
  get '/careers' => 'home#careers'
  post '/filter_feedbacks' => 'home#filter_feedbacks'

  resources :organizations do
    collection do
      get :get_users
    end
  end

  devise_for :users
  resources :users do
    collection do
      post :registration_request
    end
  end

  resources :feedbacks do
    member do
      post :vote
      post :share
    end
  end

  resources :comments do
    member do
      post :vote
    end
  end

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
