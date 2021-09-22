class HomesController < ApplicationController
    before_action :authenticate_company! , only: [:invitation]

    def index
    end

    def invitation
    end

    def send_invitation_email
      #登録した事業所のアドレスにメール
      email = params[:email]
      current_company
      ContactMailer.invitation_mail(email, current_company).deliver
      redirect_to root_path
    end

end
