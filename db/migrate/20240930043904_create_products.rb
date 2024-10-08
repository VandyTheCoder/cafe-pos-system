class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.string :name
      t.string :status
      t.string :picture
      t.references :category, null: false, foreign_key: true
      t.text :description

      t.timestamps
    end
  end
end
