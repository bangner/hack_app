HackappNew::Application.routes.draw do

  get "admin/index"
  get "admin/questions"

  resources :schools, :path_names => { :new => 'register' }

  root 'main#index'

end
