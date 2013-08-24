Isos::Application.routes.draw do
  root :to => 'posts#index'

  resources :posts, :only => :index do
    collection do
      get :music
      get :places
      get :pictures
      get :map
    end
  end

  match '/uploads/grid/picture/image/:picture_id/:filename' => 'pictures#wall', constraints: { filename: /wall.*/ }
  match '/uploads/grid/picture/image/:picture_id/:filename' => 'pictures#gallery', constraints: { filename: /gallery.*/ }
end
