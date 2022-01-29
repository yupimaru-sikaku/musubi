# frozen_string_literal: true

class Companies::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create

    @company = Company.new(sign_up_params)
    #戻るボタンを押したときまたは、@userが保存されなかったらnewアクションを実行
    render :new and return if params[:back]
    
    ##### orderとorder_details情報を入力
    
    # 購入した商品情報を取得
    product = Product.find(sign_up_params[:product_name])
    
    # ランダムな16桁を生成
    require 'securerandom'
    order_detail_number = p SecureRandom.alphanumeric(16)
    
    # 送料を決定
    @cart_total_quantity = 1
    shipping_fee = 2070 * 1.1
    
    # 登録料を決定
    registration_fee = registration_fee()
    
    # トータル料金を決定
    billing_amount = shipping_fee + product.price + registration_fee
    
    # Orderテーブルを作成
    order = Order.create!(
      order_number: order_detail_number,
      human_name: sign_up_params[:human_name],
      postal_code: sign_up_params[:postal_code],
      address: sign_up_params[:address],
      phone_number: sign_up_params[:phone_number],
      email: sign_up_params[:email],
      shipping_fee: shipping_fee,
      billing_amount: billing_amount,
      pay_type: "銀行振込",
    )
    
    # OrderDetailテーブルを作成（商品）
    order.order_details.create(
      order_number: order_detail_number,
      model_number: product.model_number,
      product_name: product.product_name,
      price: product.price,
      quantity: 1,
    )

    # OrderDetailテーブルを作成（登録手数料）
    order.order_details.create(
      order_number: order_detail_number,
      model_number: "---",
      product_name: "登録手数料",
      price: registration_fee,
      quantity: 1,
    )
    
    # 購入された商品の在庫を減らす
    product.stock -= 1
    product.update(stock: product.stock)
    
    ###### 登録した事業所のアドレスにメール
    super
    if @company.save
      
      ContactMailer.company_signup_thanks_mail(current_company, product, registration_fee, shipping_fee).deliver
      ContactMailer.company_signup_mail(current_company, product, registration_fee).deliver
      
      # slackへ通知を送る
      # notifier = Slack::Notifier.new(ENV['WEBHOOK_URL'])
      # notifier.ping "むすびHPです。\n代理店申請がありました。"
    end
    
  end
  
  def confirm
    
    @products = Product.where(price: 30000..)
    
    @company = Company.new(sign_up_params)
    if @company.invalid?
      render :new
    end

    i = 0
    @password = ""
    while i < @company.password.length
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

  # company情報登録後に登録完了画面に飛ぶ
  def after_sign_up_path_for(resource)
    companies_sign_up_complete_path(resource)
  end
  # 編集時にパスワードと確認パスワードが一致しているか判断
  def update_resource(resource, params)
    resource.update_without_current_password(params)
  end

  # company情報更新後はcompany情報詳細に飛ぶ
  def after_update_path_for(resource)
      company_path(current_company) and return
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
