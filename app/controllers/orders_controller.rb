class OrdersController < ApplicationController
  before_action :authenticate_user! , only: [:confirm]
  before_action :push_cart, only: [:create, :confirm]
  
  def create
    return redirect_to carts_show_path, flash: {success: "カート内に商品がありません"} if session[:cart].blank?
    if params[:pay_type] == "クレジットカード払い" && !current_user.card
      session[:previous_url] = request.referer
      return redirect_to new_card_path, flash: {success: "カード情報をご登録下さい"}
    end
    
    @cart_total_price = cart_total_price(@cart)
    @ship_fee = 620
    @billing_amount = @cart_total_price + @ship_fee
    @cart_total_quantity = cart_total_quantity(@cart)
    
        # ランダムな16桁を生成
        require 'securerandom'
        order_detail_number = p SecureRandom.alphanumeric(16)

        order = Order.create!(
          order_number: order_detail_number,
          human_name: current_user.human_name,
          order_date: Time.current,
          address: current_user.address,
          billing_amount: @billing_amount,
          pay_type: params[:pay_type],
          user_id: current_user.id
        )
        
        session[:cart].each do |cart|
          order.order_details.create(
            order_number: order_detail_number,
            model_number: Product.find_by(id: cart["product_id"]).model_number,
            product_name: Product.find_by(id: cart["product_id"]).product_name,
            quantity: cart["quantity"],
            product_id: cart["product_id"].to_i,
          )
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
        cart_total_price = cart_total_price(@cart)
        ship_fee = 620
        billing_amount = cart_total_price + ship_fee
        cart_total_quantity = cart_total_quantity(@cart)

        ContactMailer.product_buy_thanks_mail(current_user, order, billing_amount).deliver
        
        session[:cart].clear
        redirect_to perchase_completed_path(order.id)

      end
    
      def perchase_completed
        @display_number = Order.find_by(id: params[:id]).order_number
      end

      def confirm
        return redirect_to carts_show_path, flash: {success: "カート内に商品がありません"} if session[:cart].blank?

        session[:previous_url] = request.referer

        @user = current_user
        # カード情報
        Payjp.api_key = ENV["PAYJP_SECRET_KEY"]
        unless Card.find_by(user_id: current_user.id).blank?
            card = Card.find_by(user_id: current_user.id)
            customer = Payjp::Customer.retrieve(card.customer_token)
            @card = customer.cards.first
        end

        @cart_total_price = cart_total_price(@cart)
        @ship_fee = 620
        @billing_amount = @cart_total_price + @ship_fee
        @cart_total_quantity = cart_total_quantity(@cart)
      end

      def push_cart
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
      end


      # カート内商品の合計金額の計算
      def cart_total_price(cart)
        cart.sum { |hash| hash[:sub_total] }
      end
      # カート内商品の合計個数
      def cart_total_quantity(cart)
        cart.sum { |hash| hash[:quantity] }
      end
    
end