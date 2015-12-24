class ProductSerializer < ActiveModel::Serializer
  attributes :id, :title, :description

  has_many :product_variants, serializer: ProductVariantSerializer

  # has_many :friends, :serializer => UserSerializer, :dont_embed_friends => true

  # def product_variants?
  #   # include! :product_variants unless @options[:dont_embed_product_variants]
  #   # @options[:product_variants]
  #   serialization_options[:product_variants]
  #   # object.association(:product_variants).loaded?
  # end

  def include_associations!
    serialization_options[:product_variants]
  end
end
