class ContactMailer < ApplicationMailer

    default from: ENV['gmail_address']
  
    def invitation_mail(email, current_company)
      @url = ENV['production_url']
      @email = email
      @current_company = current_company
      mail(subject: "招待メールが届いております", to: @email)
    end

    def product_buy_thanks_mail(current_user, order, billing_amount)
      @current_user = current_user
      @order = order
      @order_details
      @billing_amount = billing_amount
      mail(subject: "商品のご購入ありがとうございます【むすび】", to: current_user.email)
    end
    
    def contact_thanks_mail(human_name, email, contact_detail)
      @human_name = human_name
      @email = email
      @contact_detail = contact_detail
      mail(subject: "お問い合わせありがとうございます【むすび】", to: @email)
    end
    
  
  end