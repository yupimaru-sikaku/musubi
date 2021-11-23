class ContactMailer < ApplicationMailer

    default from: ENV['gmail_address']

    #------------------------------相手に送る------------------------------
  
    # 招待メールの内容
    def invitation_mail(email, current_company)
      @url = ENV['production_url']
      @email = email
      @current_company = current_company
      mail(subject: "招待メールが届いております【むすび】", to: @email)
    end

    # 商品購入時のサンクスメール
    def product_buy_thanks_mail(current_user, order, billing_amount)
      @current_user = current_user
      @order = order
      @order_details
      @billing_amount = billing_amount
      mail(subject: "商品のご購入ありがとうございます【むすび】", to: current_user.email)
    end

    # ユーザーが会員登録した時のサンクスメール
    def user_signup_thanks_mail(current_user)
      @current_user = current_user
      mail(subject: "会員登録頂きありがとうございます。【むすび】", to: current_user.email)
    end
    
    # 代理店申請した時のサンクスメール
    def company_signup_thanks_mail(current_company, product, registration_fee)
      tax = 1.1
      @current_company = current_company
      @agency_name = current_company.agency_name
      @agency_code = current_company.agency_code
      @human_name = current_company.human_name
      @postal_code = current_company.postal_code
      @address = current_company.address
      @phone_number = current_company.phone_number
      @product = product
      @registration_fee = registration_fee

      # 住所から送料を決める
      if ["北海道"].any? { |t| @address.include?(t) }
        @ship_fee = 2840 * tax
      elsif ["青森県", "秋田県", "岩手県"].any? { |t| @address.include?(t) }
        @ship_fee = 2400 * tax
      elsif ["宮城県", "山形県", "福島県"].any? { |t| @address.include?(t) }
        @ship_fee = 2290 * tax
      elsif ["茨城県", "栃木県", "群馬県", "埼玉県", "千葉県", "神奈川県", "東京都", "山梨県", "新潟県", "長野県"].any? { |t| @address.include?(t) }
        @ship_fee = 2180 * tax
      elsif ["富山県", "石川県", "福井県", "静岡県", "愛知県", "三重県", "岐阜県", "大阪府", "京都府", "滋賀県", "奈良県", "和歌山県", "兵庫県", "岡山県", "広島県", "山口県", "鳥取県", "島根県", "香川県", "徳島県", "愛媛県", "高知県"].any? { |t| @address.include?(t) }
        @ship_fee = 2070 * tax
      elsif ["福岡県", "佐賀県", "長崎県", "熊本県", "大分県", "宮崎県", "鹿児島県"].any? { |t| @address.include?(t) }
        @ship_fee = 2180 * tax
      elsif ["沖縄県"].any? { |t| @address.include?(t) }
        @ship_fee = 4160 * tax
      end
      @shipping_fee = @shipping_fee.round

      # 請求金額
      @billing_amount = @ship_fee.to_i + product.price + registration_fee

      mail(subject: "代理店登録頂きありがとうございます。【むすび】", to: current_company.email)
    end

    # 商品購入時のサンクスメール
    def product_buy_thanks_mail(current_user, order)
      @current_user = current_user
      @order = order
      @order_details
      mail(subject: "商品のご購入ありがとうございます【むすび】", to: current_user.email)
    end
    
    # 問い合わせが送られた時のサンクスメール
    def contact_thanks_mail(contact)
      @contact = contact
      mail(subject: "お問い合わせありがとうございます【むすび】", to: @contact.email)
    end

    #------------------------------通知を受け取る------------------------------
    
    # ユーザーが会員登録したことを通知するメール
    def user_signup_mail(current_user)
      @current_user = current_user
      mail(subject: "ユーザー会員登録【むすび】", to: "musubi.0316@gmail.com")
    end
    
    # 代理店申請したことを通知するメール
    def company_signup_mail(current_company, product, registration_fee)
      tax = 1.1
      @current_company = current_company
      @product = product
      @registration_fee = registration_fee
      @address = current_company.address
      # 住所から送料を決める
      if ["北海道"].any? { |t| @address.include?(t) }
        @ship_fee = 2840 * tax
      elsif ["青森県", "秋田県", "岩手県"].any? { |t| @address.include?(t) }
        @ship_fee = 2400 * tax
      elsif ["宮城県", "山形県", "福島県"].any? { |t| @address.include?(t) }
        @ship_fee = 2290 * tax
      elsif ["茨城県", "栃木県", "群馬県", "埼玉県", "千葉県", "神奈川県", "東京都", "山梨県", "新潟県", "長野県"].any? { |t| @address.include?(t) }
        @ship_fee = 2180 * tax
      elsif ["富山県", "石川県", "福井県", "静岡県", "愛知県", "三重県", "岐阜県", "大阪府", "京都府", "滋賀県", "奈良県", "和歌山県", "兵庫県", "岡山県", "広島県", "山口県", "鳥取県", "島根県", "香川県", "徳島県", "愛媛県", "高知県"].any? { |t| @address.include?(t) }
        @ship_fee = 2070 * tax
      elsif ["福岡県", "佐賀県", "長崎県", "熊本県", "大分県", "宮崎県", "鹿児島県"].any? { |t| @address.include?(t) }
        @ship_fee = 2180 * tax
      elsif ["沖縄県"].any? { |t| @address.include?(t) }
        @ship_fee = 4160 * tax
      end
      @shipping_fee = @shipping_fee.round

      # 請求金額
      @billing_amount = @ship_fee.to_i + product.price + registration_fee

      mail(subject: "代理店申請【むすび】", to: "musubi.0316@gmail.com")
    end

    # 商品購入を通知するメール
    def product_buy_mail(current_user, order, order_details)
      @current_user = current_user
      @order = order
      @order_details = order_details
      mail(subject: "商品購入【むすび】", to: "musubi.0316@gmail.com")
    end

    # 問い合わせが送られた時に通知するメール
    def contact_mail(contact)
      @contact = contact
      mail(subject: "問い合わせ【むすび】", to: "musubi.0316@gmail.com")
    end

  end