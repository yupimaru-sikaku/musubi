class Companies::InvitationsController < Devise::InvitationsController
    before_action :configure_permitted_parameters

    def new
        super
    end

    def create
        super
    end

    def edit
        super
    end

    def update
        super
    end

    def destroy
        super
    end

    private

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:invite, keys: [
        :agency_name,
        :agency_code,
        :human_name,
        :birth_day,
        :postal_code,
        :address,
        :phone_number,
        :email,
        :financial_facility_name,
        :bank_branch_name,
        :bank_account_type,
        :bank_account_number,
        :bank_account_holder,
        :invited_person_number,
        ])
    end

end