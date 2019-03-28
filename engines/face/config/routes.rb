Face::Engine.routes.draw do
  # root "home#show"
  root :to => redirect('/newsfeed')
end
