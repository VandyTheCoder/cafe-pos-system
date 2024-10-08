class CreateProductProductSizes < ActiveRecord::Migration[7.2]
  def change
    create_table :product_product_sizes do |t|
      t.references :product, null: false, foreign_key: true
      t.references :product_size, null: false, foreign_key: true
      t.float :price

      t.timestamps
    end
  end
end
