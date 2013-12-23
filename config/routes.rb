TeamMate::Application.routes.draw do

  resources :people

  resources :projects do
    resources :tasks do
      resources :task_journals
    end
    get '/root_wiki', :controller => 'wikis', :action => 'root'
    get '/wiki/:id/edit', :controller => 'wikis', :action => 'edit', :as => 'edit_wiki'
    get '/wiki/:parent_id/:subject', :controller => 'wikis', :action => 'show_or_new', :as => 'show_or_new_wiki'
    post '/wikis', :controller => 'wikis', :action => 'create'
    patch '/wiki/:id', :controller => 'wikis', :action => 'update', :as => 'wiki'
    delete '/wiki/:id', :controller => 'wikis', :action => 'destroy'
  end

  get '/my_tasks/(:type)', :controller => 'people', :action => 'tasks', :as => :my_tasks
  get '/my_activities', :controller => 'people', :action => 'activities', :as => :my_activities

  devise_for :users, :controllers => {
    :sessions => 'auth/sessions',
    :passwords => 'auth/passwords',
    :registrations => 'auth/registrations'
  }

  root :to => "projects#index"


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
