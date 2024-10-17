class RemoveProductSizeIdFromProductProductSizes < ActiveRecord::Migration[7.2]
  def change
    # Remove the foreign key constraint
    remove_foreign_key :product_product_sizes, column: :product_size_id

    # Remove the index
    remove_index :product_product_sizes, :product_size_id

    # Remove the column
    remove_column :product_product_sizes, :product_size_id
  end
end
