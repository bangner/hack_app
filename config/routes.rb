HackappNew::Application.routes.draw do

  # Super Administration
  namespace :admin do
    root 'application#index'
    resources :invitations, :only => [:index, :new, :create]
  end

  # Schools
  resources :schools, :only => [:index, :show]
  namespace :school do
    resources :admins, :only => [:index, :new, :create], :path_names => { 'new' => 'register' }
  end

  # Login/Logout
  get 'login', to: 'application#login_get', as: 'login'
  post 'login', to: 'application#login_post', as: 'login_post'
  get 'logout', to: 'application#logout', as: 'logout'

  # Home
  root 'application#index', as: 'home'

end