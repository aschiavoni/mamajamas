Mamajamas::Application.routes.draw do
  resources :users, only: [ :edit, :update ]
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
               omniauth_callbacks: "users/omniauth_callbacks"
             })

  devise_scope :user do
    get "/registrations/facebook" => "registrations#facebook"
    put "/registrations/facebook" => "registrations#facebook"
    post "/registrations/facebook/update" => "registrations#facebook_update"
    post "/registrations/facebook/friends" => "registrations#facebook_friends_update"
  end

  resources :friends, only: [ :index ]
  resources :relationships, only: [ :create, :destroy ]

  resource :list, only: [ :show ] do
    resources :list_items
  end
  get "/list/:category" => "lists#show", as: :list_category

  scope "list/:category" do
    resources :list_items
  end

  scope "api" do
    defaults(format: "json") do
      get "categories" => "categories#index"
      get "categories/:category_id" => "product_types#index"
      get "categories/:category_id/:product_type_id" => "products#index"
    end
  end

  get '/robots.txt' => 'robots#show'
  root :to => 'home#index'
end
