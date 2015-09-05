Rails.application.routes.draw do
  resources :products
  match "/pages/amazon" => "pages#amazon", via: [ :post, :get ]
  match "/pages/amazon_redirect" => "pages#amazon_redirect", via: [ :post, :get]
  root to: 'visitors#index'
end
