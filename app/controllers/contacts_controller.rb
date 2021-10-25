class ContactsController < ApplicationController

    def new
        @contact = Contact.new()
    end
    
    def create
        @contact = Contact.new(contact_params)
        
        if @contact.save
            contact = @contact
            # サンクスメールを送信
            ContactMailer.contact_thanks_mail(contact).deliver
            ContactMailer.contact_mail(contact).deliver
            # slackへ通知を送る
            notifier = Slack::Notifier.new(ENV['WEBHOOK_URL'])
            notifier.ping "むすびHPです。\n問い合わせがありました。"
            return redirect_to contanct_complete_contacts_path
        else
            render :new
        end
    end

    def contanct_complete
    end

    private

    def contact_params
        params.require(:contact).permit(
            :human_name,
            :furigana,
            :email,
            :phone_number,
            :contact_detail,
        )
    end
end
