Rails.application.routes.draw do
  namespace :api do
    # APIのルートをここに定義
    # 例：
    root 'home#index'
    resources :users
    resources :posts
    resources :tasks
  end
end
