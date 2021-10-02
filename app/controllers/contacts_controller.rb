class ContactsController < ApplicationController

    def new
        @contact = Contact.new()
    end
    
    def create
        @contact = Contact.new(contact_params)
        
        if @contact.save
            # サンクスメールを送信
            human_name = params[:contact][:human_name]
            email = params[:contact][:email]
            contact_detail = params[:contact][:contact_detail]
            ContactMailer.contact_thanks_mail(human_name, email, contact_detail).deliver
            redirect_to root_path
        else
            render :new
        end
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
