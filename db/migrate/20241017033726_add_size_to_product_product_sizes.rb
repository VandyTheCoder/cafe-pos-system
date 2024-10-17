class AddSizeToProductProductSizes < ActiveRecord::Migration[7.2]
  def change
    add_column :product_product_sizes, :size, :string
  end
end
