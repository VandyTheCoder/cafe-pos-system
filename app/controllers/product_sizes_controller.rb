class ProductSizesController < ApplicationController
  before_action :set_product_size, only: %i[ show edit update destroy ]

  # GET /product_sizes
  def index
    @product_sizes = ProductSize.all
  end

  # GET /product_sizes/1
  def show
  end

  # GET /product_sizes/new
  def new
    @product_size = ProductSize.new
  end

  # GET /product_sizes/1/edit
  def edit
  end

  # POST /product_sizes
  def create
    @product_size = ProductSize.new(product_size_params)

    if @product_size.save
      redirect_to @product_size, notice: "Product size was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /product_sizes/1
  def update
    if @product_size.update(product_size_params)
      redirect_to @product_size, notice: "Product size was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /product_sizes/1
  def destroy
    @product_size.destroy!
    redirect_to product_sizes_url, notice: "Product size was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product_size
      @product_size = ProductSize.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_size_params
      params.require(:product_size).permit(:name, :size, :capacity, :unit, :description)
    end
end
