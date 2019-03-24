Face::Engine.routes.draw do
  # root "home#show"
  root :to => redirect('/algowiki_entities')
end
