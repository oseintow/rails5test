class PrSerializer < ActiveModel::Serializer
  attributes :id, :title, :description

  has_many :product_variants
end
