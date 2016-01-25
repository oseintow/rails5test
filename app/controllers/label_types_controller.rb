class LabelTypesController < ApplicationController
  before_action :set_label_type, only: [:show, :edit, :update, :destroy]

  # GET /label_types
  def index
    @label_types = LabelType.all
  end

  # GET /label_types/1
  def show
  end

  # GET /label_types/new
  def new
    @label_type = LabelType.new
  end

  # GET /label_types/1/edit
  def edit
  end

  # POST /label_types
  def create
    @label_type = LabelType.new(label_type_params)

    if @label_type.save
      redirect_to @label_type, notice: 'Label type was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /label_types/1
  def update
    if @label_type.update(label_type_params)
      redirect_to @label_type, notice: 'Label type was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /label_types/1
  def destroy
    @label_type.destroy
    redirect_to label_types_url, notice: 'Label type was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_label_type
      @label_type = LabelType.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def label_type_params
      params.require(:label_type).permit(:name, :label_id)
    end
end
