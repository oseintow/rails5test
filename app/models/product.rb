# require 'arel-helpers'
class Product < ActiveRecord::Base
  # include BaseModel
  # include ArelHelpers::ArelTable
  has_many :product_variants
  has_one :product_image

  accepts_nested_attributes_for :product_variants, :product_image

  # def as_json(options={})
  #   super(:except => [:created_at, :updated_at],
  #     :include => {
  #       :product_variants => {:only => [:id, :name]}
  #     }
  #   )
  # end
end
