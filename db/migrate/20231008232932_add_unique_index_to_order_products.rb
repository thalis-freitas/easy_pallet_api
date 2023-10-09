class AddUniqueIndexToOrderProducts < ActiveRecord::Migration[7.1]
  def change
    add_index :order_products, [:product_id, :order_id], unique: true
  end
end
