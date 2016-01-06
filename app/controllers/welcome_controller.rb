require_dependency "product_repository"
require_dependency "product_variant_repository"


class WelcomeController < ApplicationController
  # respond_to :html, :json

  def initialize(product = Domain::Repositories::ProductRepository.new, product_variant = Domain::Repositories::ProductVariantRepository.new)
    @product = product
    @product_variant = product_variant
  end

  def index
    # @pr = Product.all
    @pr = @product.all(params)
    # @pr = Product.page(2).per(1)
    # @prv = @product_variant.all(params)

    # render :json => @pr.to_json
    render :json => @pr.to_json(:include => $associations)
    #   format.html # index.html.erb
    #   format.xml  { render :xml => @pr }
    #   format.json { render :json =>@pr }
    # end

    # respond_with @pr
  end

end
