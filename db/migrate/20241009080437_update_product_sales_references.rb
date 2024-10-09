class UpdateProductSalesReferences < ActiveRecord::Migration[7.2]
  def change
    # Remove the existing columns
    remove_reference :product_sales, :product, foreign_key: true
    remove_reference :product_sales, :product_size, foreign_key: true

    # Add the new reference
    add_reference :product_sales, :product_product_size, foreign_key: true
  end
end
