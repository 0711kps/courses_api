Rails.application.routes.draw do
  resources :users, only: %i[create show update destroy] do
    get 'search'
    member do
      get 'courses'
    end
  end

  resources :courses, only: %i[show] do
    member do
      get 'users'
      resources :users, only: %i[create destroy] do
      end
    end
  end

  resources :enrollment, only: %i[] do
    
  end
end
