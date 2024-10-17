class RenameProductProductSizeIdToProductSizeIdInProductSales < ActiveRecord::Migration[7.2]
  def change
    # Rename the column
    rename_column :product_sales, :product_product_size_id, :product_size_id

    # Remove the index
    if index_exists?(:product_sales, :product_product_size_id, name: "index_product_sales_on_product_product_size_id")
      remove_index :product_sales, name: "index_product_sales_on_product_product_size_id"
    end

    # If there is a foreign key constraint, rename it
    if foreign_key_exists?(:product_sales, :product_product_size_id)
      remove_foreign_key :product_sales, column: :product_product_size_id
      add_foreign_key :product_sales, :product_sizes, column: :product_size_id
    end
  end
end
