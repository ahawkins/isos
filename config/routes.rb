Isos::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

  root :to => 'home#index'

  match '/music' => 'home#music'
  match '/places' => 'home#places'
  match '/pictures' => 'home#pictures'
  match '/messages' => 'home#messages'
end
