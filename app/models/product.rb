# require 'arel-helpers'
class Product < ActiveRecord::Base
  # include BaseModel
  # include ArelHelpers::ArelTable
  has_many :product_variants
end
