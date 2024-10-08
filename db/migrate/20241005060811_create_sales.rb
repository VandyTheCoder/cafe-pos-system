class CreateSales < ActiveRecord::Migration[7.2]
  def change
    create_table :sales do |t|
      t.string :code
      t.string :status, default: "Pending"
      t.string :customer_name
      t.string :customer_phone_number
      t.text :note
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
