class PdfsController < ApplicationController
    
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


end
