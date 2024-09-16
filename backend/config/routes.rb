Rails.application.routes.draw do
  # apiの基本rootは /api/v1
  namespace :api do
    namespace :v1 do
      root to: 'home#index'

      resources :quests, param: :uuid, except: %i[new show] do
        delete :trashed
        resources :courses, param: :uuid, only: %i[index update destroy]
      end

      resources :courses, param: :uuid, except: %i[new index show] do
        delete :trashed
        resources :stages, param: :uuid, only: %i[index update destroy]
      end

      resources :stages, param: :uuid, except: %i[new index show] do
        delete :trashed
        resources :questions, param: :uuid, only: %i[index update destroy]
      end

      resources :questions, param: :uuid, except: %i[new index show] do
        delete :trashed
        post :answer
        resources :false_answers, param: :uuid, only: %i[create update destroy] do
          delete :trashed
        end
        resources :words, param: :uuid, only: %i[index update destroy]
      end

      resources :words, param: :uuid, except: %i[new index show] do
        delete :trashed
      end

    end
  end

end
