class HomesController < ApplicationController
    before_action :authenticate_company! , only: [:invitation]

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

end
