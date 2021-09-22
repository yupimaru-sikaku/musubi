class DeviseCreateCompanies < ActiveRecord::Migration[6.0]
  def change
    create_table :companies do |t|

      # 代理店名
      t.string :agency_name, null: false, unique: true
      # 招待コード
      t.string :invitation_code
      # 代理店コード
      t.string :agency_code, unique: true
      # 代表取締役名または代表社員名（代表者）
      t.string :human_name, null: false
      # 代表者の生年月日
      t.string :birth_day, null: false
      # 代理店の郵便番号
      t.integer :postal_code, null: false
      # 代理店の住所
      t.string :address, null: false
      # 代理店の電話番号
      t.string :phone_number, null: false
      # 代理店のメールアドレス
      t.string :email, null: false, default: ""
      # 金融機関名（ゆうちょ）
      t.string :financial_facility_name, null: false
      # 支店名（店番）
      t.string :bank_branch_name, null: false
      # 口座種別
      t.string :bank_account_type, null: false
      # 口座番号
      t.integer :bank_account_number, null: false
      # 口座名義人（カナ）
      t.string :bank_account_holder, null: false
      # 招待して登録した人の数
      t.integer :invited_person_number, null: false, default: 0

      # パスワード
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      # t.integer  :sign_in_count, default: 0, null: false
      # t.datetime :current_sign_in_at
      # t.datetime :last_sign_in_at
      # t.string   :current_sign_in_ip
      # t.string   :last_sign_in_ip

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at


      t.timestamps null: false
    end

    add_index :companies, :email,                unique: true
    add_index :companies, :reset_password_token, unique: true
    # add_index :companies, :confirmation_token,   unique: true
    # add_index :companies, :unlock_token,         unique: true
  end
end
