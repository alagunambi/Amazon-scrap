Rails.application.routes.draw do
  resources :products
  match "/pages/amazon" => "pages#amazon", via: :post
  root to: 'visitors#index'
end
