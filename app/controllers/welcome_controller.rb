require_dependency "product_repository"
require_dependency "product_variant_repository"


class WelcomeController < ApplicationController
  # respond_to :html, :json

  def initialize(product = Domain::Repositories::ProductRepository.new, product_variant = Domain::Repositories::ProductVariantRepository.new)
    @product = product
    @product_variant = product_variant
    # @product.title
  end

  def index
    # Rails.logger.debug request.query_parameters

    @pr = @product.all(params)
    # @prv = @product_variant.all(params)
    # @pr = Product.where("id = ?",1)
    # @pr = @pr.or(Product.where("title = 'dax'"))
    # @pr = Product.where("count(product_id) > 1")
    # @pr = Product.joins(:product_variants).group("products.id").having("count(product_variants.product_id) > 1")
    # @pr = Product.includes(:product_variants).where(:product_variants => { :name => 's3'})
    # product_variant =ProductVariant.arel_table
    # pro = Product.arel_table
    # products = Arel::Table.new(:products)
    # @pr = products.project(Arel.star)
    # @pr = Product.eager_load(:product_variants).where(product_variant[:name].matches('s3').or(product_variant[:product_id].eq(1)))
    @ps = Post.all

    # render json: @pr
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pr }
      format.json { render :json => [@pr]}
      # format.json { render :json => @pr.to_json(:include => :product_variants) }
    end

    # respond_with @pr
  end

end
