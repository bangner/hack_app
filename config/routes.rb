HackappNew::Application.routes.draw do

  # Super Administration
  namespace :admin do
    resources :invitations, :only => [:index, :new, :create]
    resources :questions, :only => [:index, :new, :create]
    resources :schools, :only => [:index, :new, :create]
    root 'application#index'
  end

  # Applications
  resources :applications, :only => [:new, :create]

  # Schools
  resources :schools, :only => [:index, :show] do
    resources :admins, :only => [:index, :new, :create], :path_names => { :new => 'register' }
  end

  # Login/Logout
  get 'login', to: 'application#login_get', as: 'login'
  post 'login', to: 'application#login_post', as: 'login_post'
  get 'logout', to: 'application#logout', as: 'logout'

  # Home
  root 'application#index', as: 'home'

end
