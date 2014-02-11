Iceobs::Application.routes.draw do
  resources :observations do
    get :preview
    get :export, :on => :collection
    get :manage, :on => :collection
    post :import, :on => :collection
    resources :photos
    resources :comments      
  end
  resources :users
  resource  :cruise_info
  resources :lookups
  root :to => 'observations#index'
end
