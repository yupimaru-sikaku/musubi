class CompaniesController < ApplicationController

    before_action :authenticate_company!, only: [:show, :point_index]
    before_action :is_admin!, only: [:show, :point_index]

    def show
        @company = current_company
    end
    
    # 代理店が獲得したポイントの確認
    def point_index
        @search_params = company_point_index_search_params
        if @search_params[:year].present? && @search_params[:month].present?
            @search_params = company_point_index_search_params
            serach_day = @search_params[:year]+"-"+@search_params[:month]+"-1"
            @commitions = current_company.commitions.where(created_at: serach_day.in_time_zone.all_month)
        else
            @commitions = current_company.commitions
        end
        # fskj/d
    end

    # 代理店契約の説明
    def explain_agency
    end

    private

    def company_point_index_search_params
        params.fetch(:search, {}).permit(
          :year,
          :month,
        )
      end

    # 代理店モデルで承認された人のみオーダーの一覧を確認できる
    def is_admin!
        if current_company.is_buy == true
            return 
        else
            return company_path(current_company), flash: {success: "代理店申請承認されるまでお待ち下さい"}
        end
    end
  
end