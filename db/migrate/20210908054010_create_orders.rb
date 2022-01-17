class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      # 注文番号
      t.string :order_number, null: false, unique: true
      # 代表者名
      t.string :human_name, null: false
      # 届け先郵便番号
      t.string :postal_code, null: false
      # 届け先住所
      t.string :address, null: false
      # 代表者の電話番号
      t.string :phone_number, null: false
      # 代表者のアドレス
      t.string :email, null: false
      # 送料
      t.integer :shipping_fee, null: false
      # 請求金額
      t.integer :billing_amount, null: false
      # 振込タイプ
      t.string :pay_type, null: false
      # 決済が終了したか
      t.boolean :is_finished, null: false, default: false

      t.timestamps
    end
  end
end
