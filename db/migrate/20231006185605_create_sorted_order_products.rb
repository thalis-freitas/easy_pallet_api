class CreateSortedOrderProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :sorted_order_products do |t|
      t.references :order, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.string :layer
      t.string :quantity

      t.timestamps
    end
  end
end
