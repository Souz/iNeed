INeed::Application.routes.draw do

  devise_for :suppliers

  devise_for :admins

  devise_for :customers, :controllers => {:registrations => 'registrations'}

  match '/customer/needs/my_needs' => "customer/needs#my_needs", as: :customer_root
  match '/supplier/offers' => "supplier/offers#index", as: :supplier_root
  match '/admin/suppliers/' => "admin/suppliers#index", as: :admin_root
  root :to => 'home#index'
  match '/auth/:provider/callback' => 'authentications#create'
  match 'admins/searching' => 'admins#searching', :as => :searching
  #match 'transactions/insert_code' => 'transactions#insert_code'
  #match 'transactions/insert_code' => 'transactions#insert_code', :as => :insert_code
  #match 'needs/reporting' => 'needs#reporting'
  #match 'needs/reportneed' => 'needs#reportneed'
  #match "/needs/routing" => "needs#reportingComments"
  #match 'needs/:id/comments/reportingcomment' => 'comments#reportingcomment'
  #match 'comments/reportcomment' => 'comments#reportcomment'
  # match "/needs/routing" => "needs#reporting"
  match 'complaints/admin_index' => 'complaints#admin_index', :as => :admin_index
  match 'complaints/admin_index_redirect' => 'complaints#admin_index_redirect' , :as => :admin_index_redirect
  match 'needs/sorting' => 'needs#sorting'
  match 'customers/customer_profile' => 'customers#customer_profile'
  match 'suppliers/supplier_profile' => 'suppliers#supplier_profile'
  match 'users/change_password' => 'users#change_password'
  #match "/needs/routing" => "needs#reporting"
  match "/my_needs/create" => "my_needs#create"


  resources :authentications
  resources :home
  resources :comments do
    collection do
      get :like
      get :dislike
      get :unlike
    end
  end
  resources :complaints
  resources :transactions
  resources :offers
  resources :admins, :only => [:create, :destroy, :index] do
    collection do
      get :hide_marked_comments
      get :hide_marked_needs
      get :reported
    end
  end
  resources :updates
  resources :suppliers
  resources :customers
  resources :needs do
  resources :comments do
    collection do
      get :reportingcomment
      get :report_comment
    end
  end
  resources :message
  resources :categories
    collection do
      get :search
      get :filter
    end
  end
  resources:relatedneeds
 
  resources :autocomplete ,:only => [] do
    collection do
      get :needs
      get :needs_categories
    end
  end

  resources :categories, :only => [:show]

  namespace :admin do
    resources :categories ,:only => [:index, :create] do
      collection do
        delete :destroy
      end
    end
    resources :home, :only => [:index]
    resources :comments ,:only => [] do
      collection do
        get :reported
        get :warn
        get :ban
        get :delete
      end
    end
    resources :complaints, :only => [:index, :show] do
      collection do
        get :delete
        get :mark_as_read
        get :mark_as_unread
      end
    end
    resources :customers, :only => [:edit] do
      collection do
        get :un_ban_marked_customer
      end
    end
    resources :needs , :only => [] do
      collection do
        get :reported
        get :delete
        get :warn
        get :ban
      end
    end
    resources :suppliers, :only => [:index] do
      collection do
        get :approve
        get :reject
        get :ban
        get :warn
        get :un_ban_marked_supplier
      end
    end
    resources :users , :only => [] do
      collection do
        get :mailto_users
        get :banned
        get :un_ban_marked_user
      end
    end
    resources :questions, :only => [:index, :create]
  end

  namespace :customer do
    resources :comments do
      collection do
        post :reportingcomment
        post :report_comment
      end
    end
    resources :needs do
      collection do
        post :reporting
        post :report_need
        get  :my_needs
        post :un_need
        post :iNeed
        get :like
        get :dislike
        get :unlike
        get :clickme
     end
    end
    resources :feedback, :only => [:new, :create]
    resources :offers do
      collection do
        post :subscribe
        post :unsubscribe
      end
    end  
    resources :categories, :only => [:show]
  end


  namespace :supplier do
    resources :offers, :only => [:index] do
    	collection do
    		post :publish
        post :updatedate
        post :updatedelete
        post :activate
    	end
    end
    resources :complaints do
      collection do
        post :updatedelete
      end
    end
    resources :feedbacks, :only => [] do
      collection do
        post :report
        get :view
      end
    end
    resources :transactions, :only => [:index, :create, :new, :destroy, :show] do
      collection do
        get :insert_code
      end
    end
    resources :categories, :only => [:show] do
      collection do
        get :track
        get :untrack
        post :track
        post :untrack
      end
    end
    resources :needs, :only => [:index, :show] do
      collection do
        post :track
        post :untrack
        get  :hot_needs_supplier
        post :notify_view
        post :notify_action
        post :unnotify
      end
    end
  end



  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :registrations
      resources :keys
      resources :customers
      resources :comments
      resources :offers
      resources :needs do
        collection do
        get :getlistrelatedneeds
        post :report_need
        get :search
        post :iNeed
        post :un_need
        end
      end
     end
   end
end

