class ProductVariantSerializer < ActiveModel::Serializer
  attributes :id, :name, :product_id
  # belongs_to :product
end
