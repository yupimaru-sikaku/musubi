class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|

      # 商品名
      t.string :product_name, null: false
      # 価格
      t.integer :price, null: false, default: 0
      # 説明
      t.text :description, null: false
      # 在庫
      t.integer :stock, null: false, default: 0
      # 型番
      t.string :model_number, null: false
      # 商品種別
      t.string :product_type, null: false
      # 購入した時に獲得できるポイント
      t.float :point, null: false, default: 0.0
      # 販売利益
      t.integer :sales_profit, null: false, default: 0
      # 表示するか
      t.boolean :display, null: false, default: true

      t.timestamps
    end
  end
end
