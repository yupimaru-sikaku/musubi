class ContactMailer < ApplicationMailer

    default from: ENV['gmail_address']
  
    def invitation_mail(email, current_company)
      @url = ENV['production_url']
      @email = email
      @current_company = current_company
      mail(subject: "招待メールが届いております", to: @email)
    end
    
    # def iryo_gh_mail(gh, registered_address)
    #   @registered_address = registered_address
    #   @gh = gh
    #   mail(subject: "事業所をお探しの方がいらっしゃいます", to: @gh.pluck(:human_email))
    # end
  
  end