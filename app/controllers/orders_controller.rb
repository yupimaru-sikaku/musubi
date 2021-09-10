class OrdersController < ApplicationController

      def create
        if session[:cart].blank?
          return redirect_to carts_show_path
        end

        # ランダムな16桁を生成
        require 'securerandom'
        order_detail_number = p SecureRandom.alphanumeric(16)

        order = Order.create!(
          order_number: order_detail_number,
          agency_name: current_user.agency_name,
          human_name: current_user.human_name,
          order_date: Time.current,
          user_id: current_user.id
        )
        
        session[:cart].each do |cart|
          order.order_details.create(
            order_number: order_detail_number,
            model_number: Product.find_by(id: cart["product_id"]).model_number,
            product_name: Product.find_by(id: cart["product_id"]).product_name,
            quantity: cart["quantity"],
            address: current_user.address,
            product_id: cart["product_id"].to_i,
          )
        end
        session[:cart].clear
        redirect_to perchase_completed_path(order.id)
      end
    
      def perchase_completed
        @display_number = Order.find_by(id: params[:id]).order_number
      end

      def confirm
        return if session[:cart].blank?
  
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
        @cart_total_price = cart_total_price(@cart)
        @ship_fee = 620
        @billing_amount = @cart_total_price + @ship_fee
        @cart_total_quantity = cart_total_quantity(@cart)
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