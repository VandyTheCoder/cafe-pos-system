class AddTotalItemsToSale < ActiveRecord::Migration[7.2]
  def change
    add_column :sales, :total_items, :integer
  end
end
