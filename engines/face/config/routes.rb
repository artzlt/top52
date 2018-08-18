Face::Engine.routes.draw do
  # root "home#show"
  root :to => redirect('/top50_machines_list')
end
