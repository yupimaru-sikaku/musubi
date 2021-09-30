class CardsController < ApplicationController

  def new
    return redirect_to root_path, flash: {success: "既にカード情報が登録されています"} if current_user.card.present?
  end
  
  def create
    return redirect_to root_path, flash: {success: "既にカード情報が登録されています"} if current_user.card.present?
    Payjp.api_key = ENV["PAYJP_SECRET_KEY"]
    customer = Payjp::Customer.create(
      description: 'test', 
      card: params[:card_token] 
    )
    card = Card.new( # 顧客トークンとログインしているユーザーを紐付けるインスタンスを生成
      card_token: params[:card_token],  #カード情報
      customer_token: customer.id, # 顧客トークン
      user_id: current_user.id # ログインしているユーザー
    )
    if card.save
      if session[:previous_url].empty?
        redirect_to user_path(current_user) and return
      else
        redirect_to session[:previous_url]
        session[:previous_url] = ""
      end
    else
      redirect_to action: "new" # カード登録画面へリダイレクト
    end
  end  

  def edit
    @card = current_user.card
  end

  def update
  end
  
  def destroy
    card = current_user.card
    Payjp.api_key = ENV['PAYJP_SECRET_KEY']
    customer = Payjp::Customer.retrieve(card.customer_token)
    customer.delete
    card.delete
    redirect_to user_path
  end

end
