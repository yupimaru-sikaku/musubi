class CreateCommitions < ActiveRecord::Migration[6.0]
  def change
    create_table :commitions do |t|

      # お客さまが購入した際に、代理店が獲得したポイント
      t.float :add_point, null: false, default: 0
      # お客さまが購入前に、代理店が保有していたポイント
      t.float :company_has_point, null: false
      # お客さまが購入することで、代理店に振り込む額
      t.integer :reward_amount, null: false
      # 処理済みか
      t.boolean :is_finished, null: false, default: false
      # 代理店番号（FK)
      t.references :company, foreign_key: true
      # オーダー番号（FK)
      t.references :order, foreign_key: true

      t.timestamps
    end
  end
end
