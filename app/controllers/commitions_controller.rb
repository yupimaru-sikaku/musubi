class CommitionsController < ApplicationController
    before_action :is_master_admin!, only: [:index, :commition_company]

    def index
        @companies = Company.all.order(point: "DESC")
    end

    def commition_company
        id = params[:id]
        @company = Company.find(id)
        @commitions = Commition.where(company_id: id)
    end

    private
    # 代理店モデルで承認された人のみオーダーの一覧を確認できる
    def is_master_admin!
        if company_signed_in? && current_company.admin == true
            return
        else
            redirect_to root_path
        end
    end
end