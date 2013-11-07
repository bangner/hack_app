HackappNew::Application.routes.draw do

  # Super Administration
  namespace :admin do
    resources :accounts, :except => [:new, :create]
    resources :schools
    resources :questions
    resources :invitations, :except => [:edit]
    root :to => redirect('/admin/accounts')
  end

  # Accounts
  resources :accounts, :only => [:edit, :update]

  # Applicants
  resources :applicants, :only => [:new, :create, :edit, :update], :path_names => { :new => 'register' } do
    scope module: 'applicants' do
      resource :application, :only => [:show, :update]
    end
  end

  # Schools and nested School Admins
  resources :schools, :only => [:index, :show, :edit, :update] do
    resources :admins, :only => [:new, :create], :path_names => { :new => 'register' }
    scope module: 'schools' do
      resource :locations, :only => [:edit, :update]
      resource :applications, :only => [:edit, :update]
    end
  end
  get 'schools/:id/:slug' => 'schools#show', as: 'school_seo'

  # Apply
  get 'apply', to: 'application#apply_get', as: 'apply'
  post 'apply', to: 'application#apply_post'
  get 'apply/done', to: 'application#apply_done', as: 'apply_done'

  # Login/Logout
  get 'login', to: 'application#login_get', as: 'login'
  post 'login', to: 'application#login_post'
  get 'logout', to: 'application#logout', as: 'logout'

  # About
  get 'about', to: 'application#about', as: 'about'

  # Home
  root 'application#index', as: 'home'

end
