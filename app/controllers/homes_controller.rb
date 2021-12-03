class HomesController < ApplicationController

    before_action :is_admin! , only: [:invitation]

    def index
    end

    # 招待画面
    def invitation
    end

    # SDGs画面
    def sdgs
    end
    
    # メールを送るメソッド
    def send_invitation_email
      #登録した事業所のアドレスにメール
      email = params[:email]
      current_company
      if email != ""
        ContactMailer.invitation_mail(email, current_company).deliver
        return redirect_to invitation_complete_homes_path
      else
        redirect_to invitation_homes_path
      end
    end

    def send_user_invitation_email
      #登録した事業所のアドレスにメール
      email = params[:email]
      current_company
      if email != ""
        ContactMailer.user_invitation_mail(email, current_company).deliver
        return redirect_to invitation_complete_homes_path
      else
        redirect_to invitation_homes_path
      end
    end

    private

    # 代理店モデルで承認された人のみオーダーの一覧を確認できる
    def is_admin!
      if company_signed_in? && current_company.is_buy == true
          return
      else
          return redirect_to new_company_session_path, flash: {success: "代理店申請承認されるまでお待ち下さい"}
      end
  end


end
