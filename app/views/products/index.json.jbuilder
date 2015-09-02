json.array!(@products) do |product|
  json.extract! product, :id, :name, :price, :model, :asin, :mrp, :sale, :link, :source
  json.url product_url(product, format: :json)
end
