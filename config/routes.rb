Rails.application.routes.draw do

  resources :label_types
  resources :product_images
  resources :labels
  resources :posts, except: [:new, :edit]
  resources :product_variants
  resources :products
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  get 'all' => 'welcome#index'
  root 'welcome#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'

  # get "*path", to: redirect('/')
  get '*unmatched_route', to: 'application#raise_not_found'
  # match ':status', to: "errors#show", constraints: {status: /\d{3}/}, via: :all
end
