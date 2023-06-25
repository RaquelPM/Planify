Rails.application.routes.draw do
  resources :users do
    get '/events', to: 'users#events'
    get '/events/created', to: 'users#created_events'
  end

  resources :events do
    post '/join', to: 'events#join'
    post '/leave', to: 'events#leave'
    get '/participants', to: 'events#participants'
  end

  scope '/auth' do
    post '/login', to: 'auth#login'
  end
end
