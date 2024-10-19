class PosController < ApplicationController
  layout :set_layout
  before_action :set_sale, only: %i[ in_progress cancel complete ]

  def index
  end

  def search
    search_value = params[:search_value]
    products = Product.where(status: "Active")
    products = products.name_like(search_value) if search_value.present?
    products = products.order(:name)

    @products = products.includes(:category).map do |product|
      {
        id: product.id,
        name: product.name.truncate(20),
        picture: url_for(product.picture_as_thumbnail),
        category: product.category.name,
        sizes: product.product_sizes&.map do |pps|
          {
            id: pps.id,
            size: pps.size,
            price: pps.price
          }
        end
      }
    end

    render json: @products
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def check_out
    sale = build_sale
    if sale.save
      render json: { id: sale.id, message: "Check out success", pdf_url: sale_url(sale, format: :pdf) }
    else
      render json: { error: sale.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  def queue
    @pending_sales = Sale.where(status: "Pending").order(:created_at)
    @in_progress_sales = Sale.where(status: "In Progress").order(:created_at)
  end

  def in_progress
    if @sale.update(status: "In Progress")
      redirect_to queue_pos_path, notice: "Sale-#{@sale.code} has been moved to in progress!"
    else
      render :queue, notice: "Failed to move Sale-#{@sale.code} to in progress!"
    end
  end

  def cancel
    @sale = Sale.find(params[:id])
    if @sale.update(status: "Canceled")
      redirect_to queue_pos_path, notice: "Sale-#{@sale.code} has been canceled!"
    else
      render :queue, notice: "Failed to cancel Sale-#{@sale.code}!"
    end
  end

  def complete
    @sale = Sale.find(params[:id])
    if @sale.update(status: "Completed")
      redirect_to queue_pos_path, notice: "Sale-#{@sale.code} has been completed!"
    else
      render :queue, notice: "Failed to complete Sale-#{@sale.code}!"
    end
  end

  private
    def set_layout
      "pos"
    end

    def set_sale
      @sale = Sale.find(params[:id])
    end

    def build_sale
      Sale.new do |s|
        s.customer_name = check_out_params[:customer_name]
        s.customer_phone_number = check_out_params[:customer_phone_number]
        s.note = check_out_params[:note]
        s.user = current_user
        s.product_sales = build_product_sales
        s.amount = s.product_sales.sum(&:price)
        s.total_items = s.product_sales.size
      end
    end

    def build_product_sales
      check_out_params[:products].values.map do |product|
        price = ProductSize.find(product[:size_id]).price
        ProductSale.new do |ps|
          ps.product_size_id = product[:size_id]
          ps.price = price
          ps.sugar_level = product[:sugar_level]
        end
      end
    end

    def check_out_params
      params.require(:check_out).permit(:customer_name, :customer_phone_number, :note, products: [ :size_id, :sugar_level ])
    end
end
