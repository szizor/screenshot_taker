ScreenShots::Application.routes.draw do

  get 'signup' =>  'users#new'
  get 'login' =>  'sessions#new'
  get 'logout' =>  'sessions#destroy'

  resources :sessions
  resources :users
  resources :sitemaps do
    resources :screens
  end
  resources :tags do
    get :search, :on => :collection
    post :sort, :on => :collection
  end
  root :to => "sitemaps#index"
  match "/auth/:provider/callback" => "sessions#create"
end
