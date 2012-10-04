Mamajamas::Application.routes.draw do
  get '/robots.txt' => 'robots#show'
  root :to => 'home#index'
end
