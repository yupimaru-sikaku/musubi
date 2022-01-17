class OrdersController < ApplicationController
  before_action :authenticate_user! , only: [:confirm]
  before_action :add_info, only: [:create, :confirm]
  before_action :is_master_admin!, only: [:index]
  
  def index
    @orders = Order.all
  end

  def create
    # カート内が空ならカート画面にリダイレクト
    return redirect_to carts_show_path, flash: {success: "カート内に商品がありません"} if session[:cart].blank?
    # クレジットカード払いを選択しているが、カード情報がない場合は確認画面のURLを保持してカード情報入力画面へ
    if params[:pay_type] == "クレジットカード払い" && !current_user.card
      session[:previous_url] = request.referer
      return redirect_to new_card_path, flash: {success: "カード情報をご登録下さい"}
    end
        
    # オーダー情報作成のため、ランダムな16桁を生成
    require 'securerandom'
    order_detail_number = p SecureRandom.alphanumeric(16)

    # Orderテーブルを作成
    order = Order.create!(
      order_number: order_detail_number,
      human_name: current_user.human_name,
      postal_code: current_user.postal_code,
      address: current_user.address,
      phone_number: current_user.phone_number,
      email: current_user.email,
      shipping_fee: @shipping_fee,
      billing_amount: @billing_amount,
      pay_type: params[:pay_type],
    )
    
    # OrderDetailテーブルを作成
    session[:cart].each do |cart|
      order.order_details.create(
        order_number: order_detail_number,
        model_number: Product.find_by(id: cart["product_id"]).model_number,
        product_name: Product.find_by(id: cart["product_id"]).product_name,
        price: Product.find_by(id: cart["product_id"]).price,
        quantity: cart["quantity"],
      )
    end

    # 購入された商品の在庫を減らす
    session[:cart].each do |cart|
      product = Product.find_by(id: cart["product_id"])
      product.stock -= cart["quantity"]
      product.update(stock: product.stock)
    end

    # ポイントを入れる
    unless current_user.agency_code.blank?
      # ユーザーに紐付いている代理店を特定してポイント加点と報酬入力
      company = Company.find_by(agency_code: current_user.agency_code)
      # 購入前に代理店が持っているポイントを元に報酬額の分配比率を決定
      # ActionController
      decide_reward_distribution_ratio(current_user)
      @total_reward = 0
      session[:cart].each do |cart|
        product = Product.find_by(id: cart["product_id"])
        @total_reward += ((product.sales_profit * @tax * cart["quantity"].to_i) * @reward_distribution_ratio).round(0)
      end

      # ポイント加点の履歴を入力
      Commition.create(
        # 今回加点されるポイント
        add_point: @total_points,
        # 今までに代理店が持っていたポイント
        company_has_point: company.point,
        # 今回の報酬額
        reward_amount: @total_reward,
        is_finished: false,
        company_id: company.id,
        order_id: order.id
      )
      
      company.point +=  @total_points
      company.update(point: company.point)

    end

    # クレジットカード決済の場合、購入情報を送信
    if params[:pay_type] == "クレジットカード払い"

      Payjp.api_key = ENV["PAYJP_SECRET_KEY"] # 環境変数を読み込む
      customer_token = current_user.card.customer_token # ログインしているユーザーの顧客トークンを定義
      Payjp::Charge.create(
        amount: @billing_amount, # 商品の値段
        customer: customer_token, # 顧客のトークン
        currency: 'jpy' # 通貨の種類（日本円）
      )
    end

    # 最後にお客様と自身にメールを送信
    order_details = OrderDetail.where(order_id: order.id)
    ContactMailer.product_buy_thanks_mail(current_user, order).deliver
    ContactMailer.product_buy_mail(current_user, order, order_details).deliver
    # slackへ通知を送る
    # notifier = Slack::Notifier.new(ENV['WEBHOOK_URL'])
    # notifier.ping "むすびHPです。\n商品購入がありました。"

    # 保持しているURLを解放
    session[:previous_url] = ""
    # 保持しているカート情報を解放
    session[:cart].clear
    # 購入サンクス画面に移動
    redirect_to perchase_completed_path(order.id)

  end
    
  def perchase_completed
    @display_number = Order.find_by(id: params[:id]).order_number
  end

  def confirm
    # カート内に商品が無ければカート内詳細画面へ
    return redirect_to carts_show_path, flash: {success: "カート内に商品がありません"} if session[:cart].blank?

    # 住所変更・カード情報作成・カード情報変更の場合に確認画面に戻ってこられるように
    session[:previous_url] = request.url

    # カード情報を取得
    @user = current_user
    Payjp.api_key = ENV["PAYJP_SECRET_KEY"]
    unless Card.find_by(user_id: current_user.id).blank?
        card = Card.find_by(user_id: current_user.id)
        customer = Payjp::Customer.retrieve(card.customer_token)
        @card = customer.cards.first
    end

  end

  private

  # カート内の商品情報を追加
  def add_info
    
    # ユーザーに紐付いている代理店のポイントによって報酬の分配比率を決定
    # ActionController
    if current_user.agency_code.present?
      decide_reward_distribution_ratio(current_user)
    end

    @cart = []
    session[:cart].each do |cart|
      # 商品情報を取得
      product = Product.find_by(id: cart["product_id"])
      # その商品の合計価格 ＝ 商品の値段×単価
      sub_total = product.price * cart["quantity"].to_i
      # 各商品毎のポイント
      points_per_product = (product.point * cart["quantity"].to_i).round(2)

      next unless product

      @cart.push({ 
        product_id: product.id,
        product_name: product.product_name,
        model_number: product.model_number,
        price: product.price,
        quantity: cart["quantity"].to_i,
        sub_total: sub_total,
        images: product.images,
        points_per_product: points_per_product
      })
    end
    
    # カート内商品の合計金額の計算
    @cart_total_price = @cart.sum { |hash| hash[:sub_total] }
    # カート内商品の合計個数
    @cart_total_quantity = @cart.sum { |hash| hash[:quantity] }
    # カート内商品の合計ポイント
    @total_points = (@cart.sum { |hash| hash[:points_per_product] }).round(2)
    
    # 住所から送料を決める
    # ActionController
    address = current_user.address
    decide_shipping_fee(address, @cart_total_quantity, @cart)

    # 住所によって郵送料が決定できなかった場合
    if @shipping_fee == nil
      return redirect_to user_path(current_user), flash: {success: "住所を都道府県から入力下さい"}
    end

    # 請求金額
    @billing_amount = @cart_total_price + @shipping_fee

  end

  # 代理店モデルで承認された人のみオーダーの一覧を確認できる
  def is_master_admin!
    if company_signed_in? && current_company.admin == true
        return
    else
        redirect_to root_path
    end
  end

end