json.array!(@labels) do |label|
  json.extract! label, :id, :name, :qty, :product_variant_id
  json.url label_url(label, format: :json)
end
