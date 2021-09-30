class ProductsController < ApplicationController

    def index
        @products = Product.all
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
    
    def show
        @product = Product.find(params[:id])
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
            images: [],
        )
    end    

end