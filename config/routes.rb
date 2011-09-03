Isos::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

  root :to => 'posts#index'

  resources :posts, :only => :index do
    collection do
      get :music
      get :places
      get :pictures
      get :messages
    end
  end
end

