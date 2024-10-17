class DropProductSizesTable < ActiveRecord::Migration[7.2]
  def change
    drop_table :product_sizes
  end
end
