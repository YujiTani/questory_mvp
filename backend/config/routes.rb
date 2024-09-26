Rails.application.routes.draw do
  # apiの基本rootは /api/v1
  namespace :api do
    namespace :v1 do
      root to: 'home#index'

      resources :quests, param: :uuid, except: %i[new show] do
        member do
          delete :trashed
          put :restore
          patch :associate_courses
        end
        resources :courses, controller: 'quest_courses', param: :uuid, only: %i[index update destroy]
      end

      resources :courses, param: :uuid, except: %i[new index show] do
        member do
          delete :trashed
          put :restore
          patch :associate_stages
        end
        resources :stages, controller: 'course_stages', param: :uuid, only: %i[index update destroy]
      end

      resources :stages, param: :uuid, except: %i[new index show] do
        member do
          delete :trashed
          put :restore
          patch :associate_questions
        end
        resources :questions, controller: 'stage_questions', param: :uuid, only: %i[index update destroy]
      end

      resources :questions, param: :uuid, except: %i[new index show] do
        member do
          delete :trashed
          put :restore
          patch :associate_false_answers
        end
        resources :false_answers, controller: 'question_false_answers', param: :uuid, only: %i[index update destroy]
        resources :words, param: :uuid, only: %i[index update destroy]
      end

      resources :false_answers, param: :uuid, except: %i[new index show] do
        member do
          delete :trashed
          put :restore
        end
      end

      resources :words, param: :uuid, except: %i[new index show] do
        member do
          delete :trashed
          put :restore
        end
      end
    end
  end
end
