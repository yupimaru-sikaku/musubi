class CreateContacts < ActiveRecord::Migration[6.0]
  def change
    create_table :contacts do |t|

      # お名前
      t.string :human_name, null: false
      # ふりがな
      t.string :furigana, null: false
      # メールアドレス
      t.string :email, null: false
      # 電話番号
      t.string :phone_number
      # お問い合わせ内容
      t.string :contact_detail, null: false

      t.timestamps
    end
  end
end
