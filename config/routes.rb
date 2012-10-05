Mamajamas::Application.routes.draw do
  devise_for :users, path_names: { sign_in: "login", sign_out: "logout", sign_up: "signup" }
  get '/robots.txt' => 'robots#show'
  root :to => 'home#index'
end
