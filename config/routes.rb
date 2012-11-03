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
    get "/users/facebook" => "registrations#facebook"
    put "/users/facebook" => "registrations#facebook"
    post "/users/facebook/update" => "registrations#facebook_update"
    post "/users/facebook/friends" => "registrations#facebook_friends_update"
  end

  resources :friends, only: [ :index ]
  resources :relationships, only: [ :create, :destroy ]

  get '/robots.txt' => 'robots#show'
  root :to => 'home#index'
end
