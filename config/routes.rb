Lightning::Engine.routes.draw do
  root to: 'features#index'

  resources :features do
    resources :feature_opt_ins
  end
end
