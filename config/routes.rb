Isos::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

  root :to => 'home#music'

  match '/music' => 'home#music'
  match '/places' => 'home#places'
  match '/images' => 'home#images'
  match '/messages' => 'home#messages'
end
