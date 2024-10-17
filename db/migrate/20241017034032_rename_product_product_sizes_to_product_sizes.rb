class RenameProductProductSizesToProductSizes < ActiveRecord::Migration[7.2]
  def change
    rename_table :product_product_sizes, :product_sizes
  end
end
