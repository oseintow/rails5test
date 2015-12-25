# require 'arel-helpers'
class ProductVariant < ActiveRecord::Base
  # include BaseModel
  # include ArelHelpers::ArelTable
  belongs_to :product
  has_many :labels
end
