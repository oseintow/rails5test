require_dependency "product_repository"

class ProductsController < ApplicationController
  respond_to :json
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def initialize(product = Domain::Repositories::ProductRepository.new)
    @product = product
  end


  def index
    products = @product.all(params).to_json(:include => $associations.merge(:product_image => {}))
    render :json => products
  end


  def show
    begin
      # raise  :forbidden, "page not foun yej"
    # product_variant = ProductVariant.arel_table
    #   product = Product.includes(:product_variants).where("products.id = 1")
    #
    # render :json => product.to_json(:include => $associations.merge(:product_image => {}))

      e = 2 / 0

      product = Product.includes(:product_variants).where("products.id = 1")
      render :json => product.to_json(:include => $associations.merge(:product_image => {}))
    rescue Exception => e
        puts "==========="
        puts e
    end
    # render "products/show"

    # respond_to do |format|
    #   format.html # index.html.erb
    #   format.json { render :json => @product }
    #   # format.json { render :json => @pr.to_json(:include =>  {:product_variants  => { :include=> :labels}} ) }
    #   # format.json { render :json => @pr.to_json(:include => :product_variants) }
    # end
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:title, :description)
    end
end
