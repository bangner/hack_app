HackappNew::Application.routes.draw do

  # Super Administration
  namespace :admin do
    resources :accounts, :except => [:new, :create]
    resources :schools
    resources :questions
    resources :invitations, :except => [:edit]
    root :to => redirect('/admin/accounts')
  end

  # Applicants
  resources :applicants, :except => [:index, :show, :destroy], :path_names => { :new => 'register' }
  get 'applicants/:id/:slug' => 'applicants#show', as: 'applicant_seo'

  # Schools and School Admins
  resources :schools, :only => [:index, :show] do
    resources :admins, :only => [:index, :new, :create], :path_names => { :new => 'register' }
  end
  resources :admins, :only => [:edit, :update]
  get 'schools/:id/:slug' => 'schools#show', as: 'school_seo'

  # Apply
  get 'apply', to: 'application#apply_get', as: 'apply'
  post 'apply', to: 'application#apply_post', as: 'apply_post'

  # Login/Logout
  get 'login', to: 'application#login_get', as: 'login'
  post 'login', to: 'application#login_post', as: 'login_post'
  get 'logout', to: 'application#logout', as: 'logout'

  # Home
  root 'application#index', as: 'home'

end
