Rails.application.routes.draw do
  resources :events
  resources :users

  scope '/auth' do
    post '/login', to: 'auth#login'
  end
end
