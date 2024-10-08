class PosController < ApplicationController
  layout :set_layout

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
        sizes: product.product_product_sizes&.map do |pps|
          {
            id: pps.id,
            size: pps.product_size.size,
            price: pps.price,
          }
        end
      }
    end
  
    render json: @products
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def check_out
    check_out_params = params.require(:check_out).permit!
    check_out_hash = check_out_params.to_h
    check_out_hash.each do |key, value|
      # Process each item in the hash
      puts "Product ID: #{value['product_id']}, Size ID: #{value['size_id']}, Sugar Level: #{value['sugar_level']}"
    end
    sale = Sale.new do |s|
      s.customer_name = params['customer_name']
      s.customer_phone_number = params['customer_phone_number']
      s.note = params['note']
      s.user = current_user
    end
    if sale.save!
      render json: { message: "Check out success" }
    else
      render json: { error: sale.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  private
    def set_layout
      'pos'
    end
end
