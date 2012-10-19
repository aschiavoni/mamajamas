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
               omniauth_callbacks: "users/omniauth_callbacks"
             })

  devise_scope :user do
    get "/users/facebook" => "registrations#facebook"
    put "/users/facebook" => "registrations#facebook"
  end

  resources :friends, only: [ :index ]

  get '/robots.txt' => 'robots#show'
  root :to => 'home#index'
end
