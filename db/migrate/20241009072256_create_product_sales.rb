class CreateProductSales < ActiveRecord::Migration[7.2]
  def change
    create_table :product_sales do |t|
      t.references :sale, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.references :product_size, null: false, foreign_key: true
      t.float :price
      t.string :sugar_level

      t.timestamps
    end
  end
end
