class CreateOrderDetails < ActiveRecord::Migration[6.0]
  def change
    create_table :order_details do |t|

      # 注文番号
      t.string :order_number, null: false
      # 型番
      t.string :model_number, null: false
      # 商品名
      t.string :product_name, null: false
      # 商品の単価
      t.integer :price, null: false
      # 個数
      t.integer :quantity, null: false
      # オーダー番号（FK)
      t.references :order, foreign_key: true


      t.timestamps
    end
  end
end
