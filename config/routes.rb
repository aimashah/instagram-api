Rails.application.routes.draw do
  post "/signup", to: "auth#signup"
  post "/login", to: "auth#login"

  # Like route, correct
  post "/posts/:post_id/like", to: "likes#toggle"    # Keep this one

  # Comment route, correct
  post "/posts/:post_id/comments", to: "comments#create"   # Keep this one

  # Share route, correct
  post "/posts/:post_id/share", to: "shares#create"

  # Create post route
  post "/posts", to: "posts#create"

  # Get posts route
  get "/posts", to: "posts#index"
  # In routes.rb

  # This was a duplicate route, REMOVE it
  # post "/likes/:id", to: "likes#toggle"

  # This was a duplicate route, REMOVE it
  # post "/comments/:id", to: "comments#create"

  # Resources for posts, only allowing index and create
  resources :posts, only: [ :index, :create ]
end
