ProductShots::Application.routes.draw do

  get 'signup' =>  'users#new'
  get 'login' =>  'sessions#new'
  get 'logout' =>  'sessions#destroy'

  resources :sessions
  resources :users
  resources :stages do
    post 'sort', :on => :collection
  end
  resources :sitemaps do
    resources :screens
  end
  resources :purchases do
  end
  resources :productshots do
    post 'upload', :on => :collection
    get 'store_in_s3', :on => :collection
    get 'store_in_s3', :on => :collection
    get 'benchmark', :on => :collection
    get 'url2png_v6', :on => :collection
    get 'queue', :on => :collection
    get 'change_bg', :on => :collection
  end
  resources :tags do
    get :search, :on => :collection
    post :sort, :on => :collection
  end
  resources :packages do
  end
  root :to => "productshots#index"
  match "/auth/:provider/callback" => "sessions#create"
  match '/:id' => "productshots#shared_image"
end
