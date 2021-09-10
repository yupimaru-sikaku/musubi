class ApplicationController < ActionController::Base

    before_action :configure_permitted_parameters, if: :devise_controller?

    # CSRF対策(クロスサイトリクエストフォージェリ)
    # サイトに攻撃用のコードを仕込むことで、アクセスしたユーザーに対して意図しない操作を行わせる攻撃のことです。
    # 自分の日記や掲示板に意図しない書き込みがされたりといった被害を受ける可能性がある。
    protect_from_forgery with: :exception


    
    private

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [
          :agency_name,
          :human_name,
          :phone_number,
          :email,
          :postal_code,
          :address,
      ])
    end

end
