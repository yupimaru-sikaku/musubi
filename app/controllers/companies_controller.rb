class CompaniesController < ApplicationController

    before_action :authenticate_company!, only: [:point_index]

    def point_index
        @points = current_company.points
    end
end
