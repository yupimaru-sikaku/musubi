class CartsController < ApplicationController

    def show
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
      @cart_total_quantity = cart_total_quantity(@cart)
    end
  
    def add_cart
      # session内の商品の有無で条件分岐
      if session[:cart].blank?
        # 商品が入っていない場合
        session[:cart] = [{ product_id: params["product_id"], quantity: params["quantity"].to_i }]
        return redirect_to carts_show_path
      end
      # 商品が既に入っている場合、追加する商品が重複するかで条件分岐
      match = session[:cart].select {|cart| cart["product_id"] == params["product_id"] }
      # 重複が発生する場合
      if match.present?
        match[0]["quantity"] += params["quantity"].to_i
        # 重複が発生しない場合
      else
        session[:cart].push({ product_id: params["product_id"], quantity: params["quantity"].to_i })
      end
      redirect_to carts_show_path
    end
  
    # カート内商品の数量変更
    def change_quantity
      array_index = session[:cart].each_index.select {|i| session[:cart][i]["product_id"] == params["product_id"] }
      session[:cart][array_index[0]]["quantity"] = params["quantity"].to_i
      redirect_to carts_show_path
    end
  
    # カート内商品の削除
    def destroy_carts_item
      array_index = session[:cart].each_index.select {|i| session[:cart][i]["product_id"] == params["product_id"] }
      session[:cart].delete_at(array_index[0])
      redirect_to carts_show_path
    end
  
    # カート内商品の合計金額の計算
    def cart_total_price(cart)
      cart.sum { |hash| hash[:sub_total] }
    end
    # カート内商品の合計個数
    def cart_total_quantity(cart)
      cart.sum { |hash| hash[:quantity] }
    end

    def session_reset
      session[:cart].clear
      redirect_to products_path
    end
  end
  