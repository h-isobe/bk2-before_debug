Rails.application.routes.draw do
  root 'home#top'
  get 'home/about'
  devise_for :users
  resources :users,only: [:show,:index,:edit,:update]
  get 'follower/:id' => 'users#follower', as:'follower'
  get 'followed/:id' => 'users#followed', as:'followed'
  resources :books do
    resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end
  post 'follow/:id' => 'relationships#follow', as:'follow'
  post 'unfollow/:id' => 'relationships#unfollow', as:'unfollow'

  get 'search' => 'users#search'
  get 'maps/show'
  resources :maps, only: [:show]
end