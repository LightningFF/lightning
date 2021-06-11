Lightning::Engine.routes.draw do
  root to: 'features#index'

  resources :features do
    resources :feature_opt_ins
    resources :feature_opt_criterions
  end
end
