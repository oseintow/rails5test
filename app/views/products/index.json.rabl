collection @products
attributes :id, :title, :mon, :description

child :product_variants do
    attributes :id, :name

    child :labels do
        attributes :id, :name
    end
end