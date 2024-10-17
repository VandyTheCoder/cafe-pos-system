class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]

  # GET /products
  def index
    @grid = ProductsGrid.new(grid_params) do |scope|
      scope.page(params[:page])
    end
  end

  # GET /products/1
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to @product, notice: "Product was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /products/1
  def update
    if @product.update(product_params)
      redirect_to @product, notice: "Product was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /products/1
  def destroy
    @product.destroy!
    redirect_to products_url, notice: "Product was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(
        :name,
        :status,
        :picture,
        :category_id,
        :description,
        product_sizes_attributes: [
          :id,
          :size,
          :price,
          :_destroy
        ]
      )
    end

    def grid_params
      params.fetch(:products_grid, {}).permit(
        :name,
        :status,
        :category_id
      )
    end
end
