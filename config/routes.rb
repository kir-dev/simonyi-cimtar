SzkCimtar::Application.routes.draw do
  match '/members/reg' => 'members#reg_with_sso'

  resources :members, :except => [:edit, :destroy] do
    resources :job_positions, :only => [:create, :update, :destroy]

    # new action creates a new valuation if not exsits and redericest to edit
    resources :valuations, :except => [:show, :index, :destroy, :create]
  end

  resources :groups, :except => [:destroy] do
    member do
      post 'join'
      post 'leave'
      get 'get_memberships_tab_content'
    end
  end

  namespace :group_admin do
    resources :valuations, :only => [:index] do
      put "update_multiple", :on => :collection
    end
  end

  namespace :admin do
    resources :semesters, :except => [:show, :destroy]
  end

  # for the time being it redirected to semesters admin page
  get "admin" => "admin/semesters#index"

  match '/memberships/:id/deny' => 'groups#deny_pending_membership',
        :as => :deny_membership
  match '/memberships/:id/accept' => 'groups#accept_pending_membership',
        :as => :accept_membership

  get 'home/index'

  match '/logout' => 'members#logout'

  match '/403', :to => redirect('/403.html')
  match '/404', :to => redirect('/404.html')
  match '/500', :to => redirect('/500.html')

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
