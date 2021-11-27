class CompaniesController < ApplicationController

    before_action :authenticate_company!, only: [:show, :point_index]
    before_action :authenticate_company!, only: [:show, :point_index]

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

end
