Rails.application.routes.draw do
  devise_for :users

  root 'products#index'

  resources :products, only: [:index, :show]

  resource :cart, only: [:show] do  # Use `resource` instead of `resources`
    post 'add_to_cart', on: :collection
    delete 'remove_from_cart', on: :collection
  end

  resources :payments, only: [:new, :create] do
    collection do
      post 'payu_callback' # PayU callback endpoint
      get 'success'        # Success page after payment
      get 'failure'        # Failure page after payment
    end
  end


end
