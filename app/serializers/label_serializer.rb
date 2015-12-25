class LabelSerializer < ActiveModel::Serializer
  attributes :id, :name, :qty
  has_one :product_variant
end
