require_dependency "base_repository"

module Domain
  module Repositories
    class ProductVariantRepository < BaseRepository

      def initialize(product_variant = ProductVariant)
        super(product_variant)
      end

      def all(request)
        request(request).get
      end

      def title
        "hey there"
      end

      def body
        return "I love samsung galaxy s6"
      end

    end
  end
end