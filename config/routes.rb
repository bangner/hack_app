HackappNew::Application.routes.draw do

  namespace :admin do
    root 'application#index'
    resources :invitations
  end

  resources :schools, :path_names => { :new => 'register' }

  # Login/Logout
  get 'login', to: 'application#login_get', as: 'login'
  post 'login', to: 'application#login_post', as: 'login_post'
  get 'logout', to: 'application#logout', as: 'logout'

  root 'application#index', as: 'home'

end