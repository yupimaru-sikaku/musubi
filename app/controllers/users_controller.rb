class UsersController < ApplicationController

    before_action :authenticate_user!, only: [:show, :purchase_histroy]

    def show
        @user = current_user
        # カード情報
        Payjp.api_key = ENV["PAYJP_SECRET_KEY"]
        unless Card.find_by(user_id: current_user.id).blank?
            card = Card.find_by(user_id: current_user.id)
            customer = Payjp::Customer.retrieve(card.customer_token)
            @card = customer.cards.first
        end
    end

    def purchase_histroy
        @orders = Order.where(human_name: current_user.human_name)
    end

    # カード情報登録の規約
    def card_terms
    end

end
