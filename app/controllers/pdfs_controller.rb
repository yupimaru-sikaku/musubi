class PdfsController < ApplicationController
    
    before_action :is_master_admin!, only: [:index]

    def index

        @order = Order.find(params[:id])
        @file_type = params[:type]
        @order_details = OrderDetail.where(order_id: @order.id)

        pdf = Prawn::Document.new
        pdf = Pdf.new(@order, @order_details, @file_type)

        # 画面にPDFを表示する
        # disposition: "inline" によりPDFはダウンロードではなく画面に表示される
        send_data pdf.render,
        filename:    "#{@order.id}.pdf",
        type:        "application/pdf",
        disposition: "inline"
        
    end

    def toggle_is_finished
        order = Order.find(params[:id])
        order.update({
            is_finished: !order.is_finished
        })
        redirect_to orders_path
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
