Mamajamas::Application.routes.draw do
  devise_for(:users,
             path_names:
             {
               sign_in: "login", sign_out: "logout", sign_up: "signup"
             },
             controllers:
             {
               registrations: :registrations,
               sessions: :sessions,
               passwords: :passwords,
               confirmations: :confirmations,
               omniauth_callbacks: "users/omniauth_callbacks"
             })

  resources :users, only: [ :edit, :update ]
  devise_scope :user do
    get "/registrations/facebook" => "registrations#facebook"
    put "/registrations/facebook" => "registrations#facebook"
    post "/registrations/facebook/update" => "registrations#facebook_update"
    post "/registrations/facebook/friends" => "registrations#facebook_friends_update"
  end

  get "/profile" => "users#edit"
  put "/profile" => "users#update"
  put "/account/complete" => "users#complete"
  post "/account/complete" => "users#complete"
  get '/about' => 'pages#about', :as => :about
  get '/terms-of-service' => 'pages#terms', :as => :terms
  get '/test/error' => 'home#error'
  get '/robots.txt' => 'robots#show'

  resources :friends, only: [ :index ] do
    collection do
      post 'notify'
    end
  end

  resources :relationships, only: [ :create, :destroy ]

  resource :quiz, only: [ :show, :update ], controller: "quiz"
  resource :list, only: [ :show ] do
    resources :list_items, only: [ :index, :create, :update, :destroy ]
    get 'preview' => "public_lists#preview", as: :public_list_preview
    get 'preview/:category' => "public_lists#preview", as: :public_list_preview_category
    post 'publish' => "public_lists#publish", as: :public_list_publish
  end
  get "/list/:category" => "lists#show", as: :list_category

  scope "list/:category" do
    resources :list_items
  end

  namespace "admin" do
    root :to => "admin#index", as: "admin"
    get "become/:username" => "admin#become"

    resources :product_types, except: [ :show ]
    resources :categories, only: [ :index ], shallow: true do
      resources :product_types, except: [ :show ]
    end
  end

  scope "api" do
    defaults(format: "json") do
      get "categories" => "categories#index"
      get "categories/:category_id" => "product_types#index"
      get "products" => "products#index"
      get "age_ranges" => "age_ranges#index"
      get "list/product_types" => "lists#product_types"
      get "list/suggestions" => "lists#suggestions"
      get "list/suggestions/:category" => "lists#suggestions"
      post "kids" => "quiz#update_kid"
      put "update_zip_code" => "quiz#update_zip_code"
      post "prune_list" => "quiz#prune_list"
      post "list_item_images" => "list_item_images#create"
    end
  end

  get ":slug" => "public_lists#show", as: :public_list
  get ":slug/:category" => "public_lists#show", as: :public_list_category

  root :to => 'home#index'
end
