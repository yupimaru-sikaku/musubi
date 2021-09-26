class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|

      # 注文番号
      t.string :order_number, null: false
      # 代表者名
      t.string :human_name, null: false
      # 注文日
      t.string :order_date, null: false
      # 届け先
      t.string :address, null: false
      # 請求金額
      t.integer :billing_amount, null: false
      # 振込タイプ
      t.string :pay_type, null: false
      # カート番号（FK)
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
