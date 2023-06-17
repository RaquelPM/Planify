Rails.application.routes.draw do
  resources :users
  
  scope '/auth' do
    post '/login', to: 'auth#login'
  end
end
