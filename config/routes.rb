NrjEit::Application.routes.draw do
  #get "programs/index"
  #get "programs/show"
  #get "users/index"
  #get "users/new"
  #get "users/create"
  #get "users/edit"
  #get "users/update"
  #get "users/delete"


  devise_for :users

  resources :channels do
    get "events"
    resources :programs
    resources :ftps
    resources :channel_ftps, only: [:create, :destroy]
    resources :channel_success_contacts, only: [:create, :destroy]
    resources :channel_error_contacts, only: [:create, :destroy]
  end

  post "ftps/ping"

  resources :ftps do
    post "ping"
  end

  resources :users

  get "programs/events"

  resources :programs do
    get "events"#, on: :collection
    post "transfer"
  end

  resources :events, only: [:edit]
 

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'programs#index'

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
