class CreateProductSizes < ActiveRecord::Migration[7.2]
  def change
    create_table :product_sizes do |t|
      t.string :name
      t.string :size
      t.string :capacity
      t.string :unit
      t.text :description

      t.timestamps
    end
  end
end
