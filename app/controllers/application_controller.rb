class ApplicationController < ActionController::Base

    before_action :configure_permitted_parameters, if: :devise_controller?

    # CSRF対策(クロスサイトリクエストフォージェリ)
    # サイトに攻撃用のコードを仕込むことで、アクセスしたユーザーに対して意図しない操作を行わせる攻撃のことです。
    # 自分の日記や掲示板に意図しない書き込みがされたりといった被害を受ける可能性がある。
    protect_from_forgery with: :exception

    # 住所から送料を決める
    def decide_shipping_fee(address)
      if ["北海道"].any? { |t| address.include?(t) }
        @shipping_fee = 2840 * @cart_total_quantity
      elsif ["青森県", "秋田県", "岩手県"].any? { |t| address.include?(t) }
        @shipping_fee = 2400 * @cart_total_quantity
      elsif ["宮城県", "山形県", "福島県"].any? { |t| address.include?(t) }
        @shipping_fee = 2290 * @cart_total_quantity
      elsif ["茨城県", "栃木県", "群馬県", "埼玉県", "千葉県", "神奈川県", "東京都", "山梨県", "新潟県", "長野県"].any? { |t| address.include?(t) }
        @shipping_fee = 2180 * @cart_total_quantity
      elsif ["富山県", "石川県", "福井県", "静岡県", "愛知県", "三重県", "岐阜県", "大阪府", "京都府", "滋賀県", "奈良県", "和歌山県", "兵庫県", "岡山県", "広島県", "山口県", "鳥取県", "島根県", "香川県", "徳島県", "愛媛県", "高知県"].any? { |t| address.include?(t) }
        @shipping_fee = 2070 * @cart_total_quantity
      elsif ["福岡県", "佐賀県", "長崎県", "熊本県", "大分県", "宮崎県", "鹿児島県"].any? { |t| address.include?(t) }
        @shipping_fee = 2180 * @cart_total_quantity
      elsif ["沖縄県"].any? { |t| address.include?(t) }
        @shipping_fee = 4160 * @cart_total_quantity
      end
      return @shipping_fee
    end

    private

    def configure_permitted_parameters
      # 新規登録
      devise_parameter_sanitizer.permit(:sign_up, keys: [
        # 代理店  
        # エンドユーザー
        :agency_name,
        :invitation_code,
        :agency_code,
        :human_name,
        :birth_day,
        :postal_code,
        :address,
        :phone_number,
        :email,
        :financial_facility_name,
        :bank_branch_name,
        :bank_account_type,
        :bank_account_number,
        :bank_account_holder,
        :invited_person_number,
      ])

      # 編集
      devise_parameter_sanitizer.permit(:account_update, keys: [
        # 代理店  
        # エンドユーザー
        :agency_name,
        :invitation_code,
        :agency_code,
        :human_name,
        :birth_day,
        :postal_code,
        :address,
        :phone_number,
        :email,
        :financial_facility_name,
        :bank_branch_name,
        :bank_account_type,
        :bank_account_number,
        :bank_account_holder,
        :invited_person_number,
      ])

      # # 招待メールの送信
      # devise_parameter_sanitizer.permit(:invite, keys: [
      #   :agency_name,
      #   :agency_code,
      #   :human_name,
      #   :birth_day,
      #   :postal_code,
      #   :address,
      #   :phone_number,
      #   :email,
      #   :financial_facility_name,
      #   :bank_branch_name,
      #   :bank_account_type,
      #   :bank_account_number,
      #   :bank_account_holder,
      #   :invited_person_number,
      # ])

      # # 招待されたユーザーがアカウントをつくるため
      # devise_parameter_sanitizer.permit(:accept_invitation, keys: [
      #   :agency_name,
      #   :agency_code,
      #   :human_name,
      #   :birth_day,
      #   :postal_code,
      #   :address,
      #   :phone_number,
      #   :email,
      #   :financial_facility_name,
      #   :bank_branch_name,
      #   :bank_account_type,
      #   :bank_account_number,
      #   :bank_account_holder,
      #   :invited_person_number,
      # ])
    end

end
