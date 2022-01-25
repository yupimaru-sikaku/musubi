class ProductsController < ApplicationController

    before_action :is_master_admin!, only: [:new, :create, :edit, :destroy]

    def index
        @products = Product.where(display: true)
    end

    def new
        @product = Product.new
    end

    def create
        @product = Product.new(product_params)
    
        if @product.valid?
          @product.save
          redirect_to products_path
        else
          render :new
        end
        
    end

    def edit
        @product = Product.find(params[:id])
    end

    def update
        @product = Product.find(params[:id])
        if @product.update(product_params)
            redirect_to product_path(@product)
        else
            render :edit
        end
    end
    
    def show
        @product = Product.find(params[:id])
    end

    def destroy
        @product = Product.find(params[:id])
        @product.destroy
        redirect_to products_path
    end
    
    # 商品紹介
    def introduction
    end
    def introduction_silver_ion_water
    end
    def introduction_dha_epa_supplement
    end
    def introduction_itoix
    end
    def introduction_electrolytic_hydrogen_water
    end
    def introduction_cell_drop
    end

    private
    
    def product_params
        params.require(:product).permit(
            :product_name,
            :price,
            :description,
            :stock,
            :model_number,
            :product_type,
            :point,
            :sales_profit,
            :product_link,
            images: [],
        )
    end

    # 代理店モデルで承認された人のみオーダーの一覧を確認できる
    def is_master_admin!
        if company_signed_in? && current_company.admin == true
            return
        else
            redirect_to root_path
        end
    end
    
end