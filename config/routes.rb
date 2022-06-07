Rails.application.routes.draw do
  resources :users, only: %i[create show update destroy] do
    collection do
      get 'search'
    end
    
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

  resources :enrollments, only: %i[create destroy show] do
    collection do
      get 'search'
    end
  end
end
