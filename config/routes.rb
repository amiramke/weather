Rails.application.routes.draw do
  get 'pages/home'
  root 'pages#home'
  namespace :api do
    post '/weather', to: 'weather#create'
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
end
