class ApplicationController < ActionController::Base

    before_action :configure_permitted_parameters, if: :devise_controller?

    # CSRF対策(クロスサイトリクエストフォージェリ)
    # サイトに攻撃用のコードを仕込むことで、アクセスしたユーザーに対して意図しない操作を行わせる攻撃のことです。
    # 自分の日記や掲示板に意図しない書き込みがされたりといった被害を受ける可能性がある。
    protect_from_forgery with: :exception

    # 住所から送料を決める
    def decide_shipping_fee(address, cart_total_quantity, cart)
      # 消費税決定
      tax = 1.1
      # 型番リスト作成
      model_number_list = cart.pluck(:model_number)
      @shipping_fee = 0

      # 銀イオン水の段ボールの数
      ag_box_quantity = 0
      # 銀イオン水のスプレーの数
      ag_spray_quantity = 0
      
      # 商品によって場合分けする
      @cart.each do |product|
        
    ######### 銀イオン水シリーズの場合
        if product[:model_number] == "AG010" || product[:model_number] == "AG011" || product[:model_number] == "AG012" || product[:model_number] == "AG013" || product[:model_number] == "AG014"
          # 銀イオン水シリーズー段ボール買いの場合
          if product[:model_number] == "AG010" || product[:model_number] == "AG011" || product[:model_number] == "AG012" || product[:model_number] == "AG013"
            ag_box_quantity  += product[:quantity]
          # 銀イオン水シリーズースプレー買いの場合
          elsif product[:model_number] == "AG014"
            ag_spray_quantity = 1
          end
        @shipping_fee = ((2070 * ag_box_quantity + 930 * ag_spray_quantity) * tax).round
        end
      end
      
      return @shipping_fee
    end

    # 登録手数料の決定
    def registration_fee
      tax = 1.1
      @registration_fee = 1000 * tax
      @registration_fee = @registration_fee.round
      return @registration_fee
    end

    # ユーザーに紐付いている代理店のポイントによって報酬の分配比率を決定
    def decide_reward_distribution_ratio(current_user)
      @tax = 1.1

      company = Company.find_by(agency_code: current_user.agency_code)
      company_point = company.point
      
      @reward_distribution_ratio = 0
      if company_point >= 0 && company_point <= 50
        @reward_distribution_ratio = 0.3
      elsif company_point >= 51 && company_point <= 100
        @reward_distribution_ratio = 0.4
      elsif company_point >= 101 && company_point <= 500
        @reward_distribution_ratio = 0.5
      elsif company_point >= 501 && company_point <= 1000
        @reward_distribution_ratio = 0.6
      elsif company_point >= 1001
        @reward_distribution_ratio = 0.7
      end

      return @reward_distribution_ratio
      return @tax
    end
    
    private
    
    def configure_permitted_parameters
      # 新規登録
      devise_parameter_sanitizer.permit(:sign_up, keys: [
        # 代理店  
        # エンドユーザー
        :agency_name,
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
        :product_name,
      ])

      # 編集
      devise_parameter_sanitizer.permit(:account_update, keys: [
        # 代理店  
        # エンドユーザー
        :agency_name,
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
      ])

    end

end
