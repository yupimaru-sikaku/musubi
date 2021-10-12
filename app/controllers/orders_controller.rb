class OrdersController < ApplicationController
  before_action :authenticate_user! , only: [:confirm]
  before_action :add_info, only: [:create, :confirm]
  
  def create
    return redirect_to carts_show_path, flash: {success: "カート内に商品がありません"} if session[:cart].blank?
    if params[:pay_type] == "クレジットカード払い" && !current_user.card
      session[:previous_url] = request.referer
      return redirect_to new_card_path, flash: {success: "カード情報をご登録下さい"}
    end
        
    # ランダムな16桁を生成
    require 'securerandom'
    order_detail_number = p SecureRandom.alphanumeric(16)
    # Orderテーブルを作成
    order = Order.create!(
      order_number: order_detail_number,
      human_name: current_user.human_name,
      address: current_user.address,
      billing_amount: @billing_amount,
      pay_type: params[:pay_type],
    )
    
    # OrderDetailテーブルを作成
    session[:cart].each do |cart|
      order.order_details.create(
        order_number: order_detail_number,
        model_number: Product.find_by(id: cart["product_id"]).model_number,
        product_name: Product.find_by(id: cart["product_id"]).product_name,
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
      # ユーザーに紐付いている代理店を特定
      company_id = Company.find_by(agency_code: current_user.agency_code).id
      # 加算するポイントの初期化
      syodoku_point = 0
      # 各商品ごとのポイントを加算していく
      session[:cart].each do |cart|
        if Product.find_by(id: cart["product_id"]).product_type == "消毒液"
          quantity = cart["quantity"]
          syodoku_point += quantity
        end
      end
      # 購入手続きで各ポイントが1以上付与の予定なら各ポイントに加算していく
      if syodoku_point >= 1 
        if Point.find_by(point_type: "消毒液", company_id: company_id)
          point = Point.find_by(point_type: "消毒液", company_id: company_id)
          syodoku_point += point.count
          point.update(count: syodoku_point)
        else
          Point.create(
            point_type: "消毒液",
            count: syodoku_point,
            company_id: company_id
          )
        end
      end
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

    # 最後にメールを送信
    ContactMailer.product_buy_thanks_mail(current_user, order, @billing_amount).deliver
    
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
    return redirect_to carts_show_path, flash: {success: "カート内に商品がありません"} if session[:cart].blank?

    session[:previous_url] = request.url

    @user = current_user
    # カード情報
    Payjp.api_key = ENV["PAYJP_SECRET_KEY"]
    unless Card.find_by(user_id: current_user.id).blank?
        card = Card.find_by(user_id: current_user.id)
        customer = Payjp::Customer.retrieve(card.customer_token)
        @card = customer.cards.first
    end

  end

  private

  def add_info

    @cart = []
    session[:cart].each do |cart|
      product = Product.find_by(id: cart["product_id"])
      sub_total = product.price * cart["quantity"].to_i
      next unless product

      @cart.push({ 
        product_id: product.id,
        product_name: product.product_name,
        price: product.price,
        quantity: cart["quantity"].to_i,
        sub_total: sub_total,
        images: product.images
      })
    end
    
    # カート内商品の合計金額の計算
    @cart_total_price = @cart.sum { |hash| hash[:sub_total] }
    # カート内商品の合計個数
    @cart_total_quantity = @cart.sum { |hash| hash[:quantity] }
    
    # 住所から送料を決める
    address = current_user.address
    if ["北海道"].any? { |t| address.include?(t) }
      @ship_fee = 2840 * @cart_total_quantity
    elsif ["青森県", "秋田県", "岩手県"].any? { |t| address.include?(t) }
      @ship_fee = 2400 * @cart_total_quantity
    elsif ["宮城県", "山形県", "福島県"].any? { |t| address.include?(t) }
      @ship_fee = 2290 * @cart_total_quantity
    elsif ["茨城県", "栃木県", "群馬県", "埼玉県", "千葉県", "神奈川県", "東京都", "山梨県", "新潟県", "長野県"].any? { |t| address.include?(t) }
      @ship_fee = 2180 * @cart_total_quantity
    elsif ["富山県", "石川県", "福井県", "静岡県", "愛知県", "三重県", "岐阜県", "大阪府", "京都府", "滋賀県", "奈良県", "和歌山県", "兵庫県", "岡山県", "広島県", "山口県", "鳥取県", "島根県", "香川県", "徳島県", "愛媛県", "高知県"].any? { |t| address.include?(t) }
      @ship_fee = 2070 * @cart_total_quantity
    elsif ["福岡県", "佐賀県", "長崎県", "熊本県", "大分県", "宮崎県", "鹿児島県"].any? { |t| address.include?(t) }
      @ship_fee = 2180 * @cart_total_quantity
    elsif ["沖縄県"].any? { |t| address.include?(t) }
      @ship_fee = 4160 * @cart_total_quantity
    end

    # 請求金額
    @billing_amount = @cart_total_price + @ship_fee


  end

end