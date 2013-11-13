HackappNew::Application.routes.draw do

  # Admin console
  namespace :admin do
    resources :accounts, :except => [:new, :create]
    resources :bootcamps
    resources :questions
    resources :invitations, :except => [:edit]
    root :to => redirect('/admin/accounts')
  end

  # Public facing site
  scope module: 'public' do

    # Accounts
    resources :accounts, only: [:edit, :update], path_names: { edit: 'settings' } do
      get 'logout'
      collection do
        scope module: 'accounts' do
          resource :login, only: [:new, :create], path_names: { new: '' }, to: 'login'
        end
      end
    end

    # Applicants
    resources :applicants, only: [:new, :create], path_names: { new: 'register' } do
      scope module: 'applicants' do
        resource :application, :only => [:show, :update], to: 'application'
        resource :application, :only => [:new, :create], :path => 'apply', path_names: { new: '' }, to: 'application'
        get 'applied', to: 'application'
        scope module: 'settings' do
          resource :settings, only: [] do
            resource :profile, only: [:edit, :update], path_names: { edit: '' }, to: 'profile'
          end
        end
      end
    end

    # Bootcamps
    resources :bootcamps, only: [:index, :show] do
      get ':slug' => 'bootcamps#show', as: 'seo'
      scope module: 'bootcamps' do
        resources :admins, only: [:new, :create], path_names: { new: 'register' }
        scope module: 'settings' do
          resource :settings, only: [] do
            resource :profile, :only => [:edit, :update], path_names: { edit: '' }, to: 'profile'
            resource :locations, :only => [:edit, :update], path_names: { edit: '' }
            resource :applications, :only => [:edit, :update], path_names: { edit: '' }
          end
        end
      end
    end

    # Entry routes
    scope module: 'front' do
      get 'about'
      get 'blog', :to => redirect('http://blog.hackapp.co')
    end

    # Root
    root 'front#index'

  end

end
