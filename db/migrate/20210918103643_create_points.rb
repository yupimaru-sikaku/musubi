class CreatePoints < ActiveRecord::Migration[6.0]
  def change
    create_table :points do |t|

      # ポイント種類
      t.string :point_type, null: false
      # カウント
      t.integer :count, null: false, default: 0
      # 代理店（FK)
      t.references :company, foreign_key: true

      t.timestamps
    end
  end
end
