class AddAmountToSale < ActiveRecord::Migration[7.2]
  def change
    add_column :sales, :amount, :float
  end
end
