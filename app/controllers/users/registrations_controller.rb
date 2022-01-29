# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]

  # GET /resource/sign_up
  # def new
  #   super
  # end
  
  # POST /resource
  def create
    @user = User.new(sign_up_params)
    #戻るボタンを押したときまたは、@userが保存されなかったらnewアクションを実行
    render :new and return if params[:back]

    
    super
    
    # 登録したユーザーのアドレスにメール
    # 登録したことをメールとSlackで通知
    if @user.save

      # 登録した事業所のアドレスにメール
      ContactMailer.user_signup_thanks_mail(current_user).deliver
      ContactMailer.user_signup_mail(current_user).deliver

      # slackへ通知を送る
      # notifier = Slack::Notifier.new(ENV['WEBHOOK_URL'])
      # notifier.ping "むすびHPです。\n ユーザー会員登録がありました。"
    end

  end

  def confirm
    
    @user = User.new(sign_up_params)
    if @user.invalid?
      render :new
    end

    i = 0
    @password = ""
    while i < @user.password.length
      @password += "*"
      i += 1
    end
  end

  def complete
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # user情報登録後に登録完了画面に飛ぶ
  def after_sign_up_path_for(resource)
    users_sign_up_complete_path(resource)
  end
  # 編集時にパスワードと確認パスワードが一致しているか判断
  def update_resource(resource, params)
    resource.update_without_current_password(params)
  end

  # user情報更新後にsessionのURLがあればそこに飛ぶ
  def after_update_path_for(resource)
    if session[:previous_url].present? 
      session[:previous_url]
    else
      user_path(current_user) and return
    end
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
