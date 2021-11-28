class CompaniesController < ApplicationController

    before_action :is_admin!, only: [:point_index]

    def show
        @company = current_company
    end
    
    # 代理店が獲得したポイントの確認
    def point_index
        @points = current_company.points
    end

    # 代理店契約の説明
    def explain_agency
    end

    private

    # 代理店モデルで承認された人のみオーダーの一覧を確認できる
    def is_admin!
        if company_signed_in? && current_company.is_buy == true
            return
        else
            return redirect_to company_path(current_company), flash: {success: "代理店申請承認されるまでお待ち下さい"}
        end
    end

end
