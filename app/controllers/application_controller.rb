class ApplicationController < ActionController::Base

    before_action :configure_permitted_parameters, if: :devise_controller?

    # CSRF対策(クロスサイトリクエストフォージェリ)
    # サイトに攻撃用のコードを仕込むことで、アクセスしたユーザーに対して意図しない操作を行わせる攻撃のことです。
    # 自分の日記や掲示板に意図しない書き込みがされたりといった被害を受ける可能性がある。
    protect_from_forgery with: :exception

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
