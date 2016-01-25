class Label < ApplicationRecord
  belongs_to :product_variant
  has_many :label_types
end
