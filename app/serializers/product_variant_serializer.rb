# class ProductVariantSerializer < ActiveModel::Serializer
#   attributes :id, :name
#   # has_one :product
#   has_many :labels, serializer: LabelSerializer
#
#   def include_labels?
#     object.association(:labels).loaded?
#   end
#
#   # def labels?
#   #   # include! :labels unless @options[:dont_embed_labels]
#   #   # @options[:labels]
#   #   # serialization_options[:product_variants]
#   #   object.association(:labels).loaded?
#   # end
#
#   # def include_associations!
#   #   serialization_options[:labels]
#   # end
# end
