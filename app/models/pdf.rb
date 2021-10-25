class Pdf < Prawn::Document
    
    def initialize(order, order_details, file_type)
    
        super()

        # pdfs_controllerから請求書に必要な情報を格納
        @order = order
        @order_details = order_details
        @file_type = file_type
        # 日本語フォントを使用しないと日本語使えません
        font_families.update('ipag' => { normal: 'ipag.ttf', bold: 'ipag.ttf' })
        font 'ipag'
        
        # 座標を表示
        # stroke_axis

        if @file_type == "請求書"

            # ヘッダー
            draw_text '請求書', at: [10, 670], size: 28
            draw_text "#{@order.created_at.strftime('%Y/%m/%d')}", at: [450, 670], size: 12
            stroke_color "90ee90"
            stroke_horizontal_line 0, 540, :at=> 660
            stroke_horizontal_line 0, 540, :at=> 659
            stroke_horizontal_line 0, 540, :at=> 658
            stroke_horizontal_line 0, 540, :at=> 657
            stroke_horizontal_line 0, 540, :at=> 656
            stroke_horizontal_line 0, 540, :at=> 655
            
            # お名前
            draw_text "#{@order.human_name} 様", at: [10, 620], size: 16
            
            # 請求金額＋その他
            bounding_box([5,555], :width => 0, :height => 0) do 
                stroke_color 'FFFFFF' 
                stroke do 
                fill_color 'd8efcb' 
                fill_and_stroke_rounded_rectangle [cursor,cursor], 190, 40, 0
                fill_color '000000' 
                end 
            end 
            draw_text "毎度ありがとうございます。", at: [10, 580], size: 12
            draw_text "下記の通り、ご請求申し上げます。", at: [10, 560], size: 12
            draw_text "御支払い金額", at: [10, 530], size: 14
            draw_text "¥#{@order.billing_amount.to_s(:delimited)}", at: [120, 530], size: 14
            draw_text "支払い期限:", at: [10, 500], size: 10
            
            
            # 株式会社むすび情報
            draw_text "株式会社むすび", at: [330, 620], size: 14
            draw_text "〒577-0004", at: [330, 600], size: 12
            draw_text "〒577-0004", at: [330, 600], size: 12
            draw_text "大阪府東大阪市稲田新町二丁目14番7号", at: [330, 580], size: 12
            draw_text "TEL: 090-4360-9483", at: [330, 560], size: 12
            draw_text "FAX: 072-814-9831", at: [330, 540], size: 12
            image 'app/assets/images/むすび印.png', at: [460, 570], width: 70
            
            
            # 表
            draw_text "品番・品名", at: [10, 460], size: 10
            draw_text "数量", at: [330, 460], size: 10
            draw_text "単価", at: [390, 460], size: 10
            draw_text "金額（税込）", at: [450, 460], size: 10
            
            count_row = 0
            @order_details.each do |product|
                # 各商品の金額（税込み）の計算
                price_per_product = product.quantity * product.price 
                
                # 品番・品名
                draw_text "#{product.product_name}", at: [20, 432 - count_row], size: 10
                # 数量
                draw_text "#{product.quantity}", at: [335, 432 - count_row], size: 10
                # 単価
                draw_text "#{product.price.to_s(:delimited)}", at: [390, 432 - count_row], size: 10
                # 金額（税込み）
                draw_text "#{price_per_product.to_s(:delimited)}", at: [450, 432 - count_row], size: 10
                
                count_row += 30
            end
            
            # 送料
            draw_text "送料", at: [20, 432 - count_row], size: 10
            draw_text "1", at: [335, 432 - count_row], size: 10
            draw_text "#{@order.shipping_fee.to_s(:delimited)}", at: [390, 432 - count_row], size: 10
            draw_text "#{@order.shipping_fee.to_s(:delimited)}", at: [450, 432 - count_row], size: 10
            
            stroke_color "d3d3d3"
            stroke_horizontal_line 10, 530, :at=> 450
            stroke_horizontal_line 10, 530, :at=> 420
            stroke_horizontal_line 10, 530, :at=> 390
            stroke_horizontal_line 10, 530, :at=> 360
            stroke_horizontal_line 10, 530, :at=> 330
            stroke_horizontal_line 10, 530, :at=> 300
            stroke_horizontal_line 10, 530, :at=> 270
            stroke_horizontal_line 10, 530, :at=> 240
            stroke_horizontal_line 10, 530, :at=> 210
            stroke_horizontal_line 10, 530, :at=> 180
            stroke_horizontal_line 10, 530, :at=> 150
            
            
            draw_text "小計（税込）", at: [330, 130], size: 10
            draw_text "#{@order.billing_amount.to_s(:delimited)}", at: [450, 130], size: 10
            draw_text "うち消費税(10%)", at: [330, 100], size: 10
            draw_text "#{(@order.billing_amount * 0.1).round.to_s(:delimited)}", at: [450, 100], size: 10
            draw_text "合計金額", at: [330, 70], size: 10
            draw_text "#{@order.billing_amount.to_s(:delimited)}", at: [450, 70], size: 10
            
            stroke_horizontal_line 330, 530, :at=> 120
            stroke_horizontal_line 330, 530, :at=> 90
            stroke_horizontal_line 330, 530, :at=> 60

            # 振込先情報
            draw_text "お振込先：大阪シティ信用金庫 高井田支店 普通預金 ８０８８９６７ カ)ムスビ", at: [10, 10], size: 10
            stroke_color "90ee90"
            stroke_horizontal_line 0, 540, :at=> 5
            stroke_horizontal_line 0, 540, :at=> 4    
            stroke_horizontal_line 0, 540, :at=> 3    
            stroke_horizontal_line 0, 540, :at=> 2    
            stroke_horizontal_line 0, 540, :at=> 1    
            stroke_horizontal_line 0, 540, :at=> 0    
        
        elsif @file_type == "納品書"

            # ヘッダー
            draw_text '納品書', at: [10, 670], size: 28
            draw_text "#{@order.created_at.strftime('%Y/%m/%d')}", at: [450, 670], size: 12
            stroke_color "90ee90"
            stroke_horizontal_line 0, 540, :at=> 660
            stroke_horizontal_line 0, 540, :at=> 659
            stroke_horizontal_line 0, 540, :at=> 658
            stroke_horizontal_line 0, 540, :at=> 657
            stroke_horizontal_line 0, 540, :at=> 656
            stroke_horizontal_line 0, 540, :at=> 655
            
            # お名前
            draw_text "#{@order.human_name} 様", at: [10, 620], size: 16
            
            # 請求金額＋その他
            bounding_box([5,555], :width => 0, :height => 0) do 
                stroke_color 'FFFFFF' 
                stroke do 
                fill_color 'd8efcb' 
                fill_and_stroke_rounded_rectangle [cursor,cursor], 190, 40, 0
                fill_color '000000' 
                end 
            end 
            draw_text "毎度ありがとうございます。", at: [10, 580], size: 12
            draw_text "下記の通り、納品致しました。", at: [10, 560], size: 12
            draw_text "合計金額", at: [10, 530], size: 14
            draw_text "¥#{@order.billing_amount.to_s(:delimited)}", at: [120, 530], size: 14
            
            # 株式会社むすび情報
            draw_text "株式会社むすび", at: [330, 620], size: 14
            draw_text "〒577-0004", at: [330, 600], size: 12
            draw_text "〒577-0004", at: [330, 600], size: 12
            draw_text "大阪府東大阪市稲田新町二丁目14番7号", at: [330, 580], size: 12
            draw_text "TEL: 090-4360-9483", at: [330, 560], size: 12
            draw_text "FAX: 072-814-9831", at: [330, 540], size: 12
            image 'app/assets/images/むすび印.png', at: [460, 570], width: 70
            
            
            # 表
            draw_text "品番・品名", at: [10, 460], size: 10
            draw_text "数量", at: [330, 460], size: 10
            draw_text "単価", at: [390, 460], size: 10
            draw_text "金額（税込）", at: [450, 460], size: 10
            
            count_row = 0
            @order_details.each do |product|
                # 各商品の金額（税込み）の計算
                price_per_product = product.quantity * product.price 
                
                # 品番・品名
                draw_text "#{product.product_name}", at: [20, 432 - count_row], size: 10
                # 数量
                draw_text "#{product.quantity}", at: [335, 432 - count_row], size: 10
                # 単価
                draw_text "#{product.price.to_s(:delimited)}", at: [390, 432 - count_row], size: 10
                # 金額（税込み）
                draw_text "#{price_per_product.to_s(:delimited)}", at: [450, 432 - count_row], size: 10
                
                count_row += 30
            end
            
            # 送料
            draw_text "送料", at: [20, 432 - count_row], size: 10
            draw_text "1", at: [335, 432 - count_row], size: 10
            draw_text "#{@order.shipping_fee.to_s(:delimited)}", at: [390, 432 - count_row], size: 10
            draw_text "#{@order.shipping_fee.to_s(:delimited)}", at: [450, 432 - count_row], size: 10
            
            stroke_color "d3d3d3"
            stroke_horizontal_line 10, 530, :at=> 450
            stroke_horizontal_line 10, 530, :at=> 420
            stroke_horizontal_line 10, 530, :at=> 390
            stroke_horizontal_line 10, 530, :at=> 360
            stroke_horizontal_line 10, 530, :at=> 330
            stroke_horizontal_line 10, 530, :at=> 300
            stroke_horizontal_line 10, 530, :at=> 270
            stroke_horizontal_line 10, 530, :at=> 240
            stroke_horizontal_line 10, 530, :at=> 210
            stroke_horizontal_line 10, 530, :at=> 180
            stroke_horizontal_line 10, 530, :at=> 150
            
            
            draw_text "小計（税込）", at: [330, 130], size: 10
            draw_text "#{@order.billing_amount.to_s(:delimited)}", at: [450, 130], size: 10
            draw_text "うち消費税(10%)", at: [330, 100], size: 10
            draw_text "#{(@order.billing_amount * 0.1).round.to_s(:delimited)}", at: [450, 100], size: 10
            draw_text "合計金額", at: [330, 70], size: 10
            draw_text "#{@order.billing_amount.to_s(:delimited)}", at: [450, 70], size: 10
            
            stroke_horizontal_line 330, 530, :at=> 120
            stroke_horizontal_line 330, 530, :at=> 90
            stroke_horizontal_line 330, 530, :at=> 60

            # 振込先情報
            stroke_color "90ee90"
            stroke_horizontal_line 0, 540, :at=> 5
            stroke_horizontal_line 0, 540, :at=> 4    
            stroke_horizontal_line 0, 540, :at=> 3    
            stroke_horizontal_line 0, 540, :at=> 2    
            stroke_horizontal_line 0, 540, :at=> 1    
            stroke_horizontal_line 0, 540, :at=> 0    

        elsif @file_type == "依頼書"

            # ヘッダー
            draw_text '郵送依頼書', at: [10, 670], size: 28
            draw_text "#{@order.created_at.strftime('%Y/%m/%d')}", at: [450, 670], size: 12
            stroke_color "90ee90"
            stroke_horizontal_line 0, 540, :at=> 660
            stroke_horizontal_line 0, 540, :at=> 659
            stroke_horizontal_line 0, 540, :at=> 658
            stroke_horizontal_line 0, 540, :at=> 657
            stroke_horizontal_line 0, 540, :at=> 656
            stroke_horizontal_line 0, 540, :at=> 655
            
            # お願い文章
            draw_text "下記の商品の郵送手配をお願い致します。", at: [10, 620], size: 16

            # 宛先
            # 注文番号
            draw_text "注文番号：#{@order.order_number}", at: [10, 580], size: 12
            # お名前
            draw_text "お名前：#{@order.human_name} 様", at: [10, 560], size: 12
            # 宛先
            draw_text "〒：#{@order.postal_code}", at: [10, 540], size: 12
            draw_text "宛先：#{@order.address}", at: [10, 520], size: 12
            # 電話番号
            draw_text "TEL：#{@order.phone_number}", at: [10, 500], size: 12
            
            # 表
            draw_text "品番・品名", at: [10, 460], size: 10
            draw_text "数量", at: [330, 460], size: 10
            
            count_row = 0
            @order_details.each do |product|
                # 各商品の金額（税込み）の計算
                price_per_product = product.quantity * product.price 
                
                # 品番・品名
                draw_text "#{product.product_name}", at: [20, 432 - count_row], size: 10
                # 数量
                draw_text "#{product.quantity}", at: [335, 432 - count_row], size: 10
                
                count_row += 30
            end
            
            stroke_color "d3d3d3"
            stroke_horizontal_line 10, 530, :at=> 450
            stroke_horizontal_line 10, 530, :at=> 420
            stroke_horizontal_line 10, 530, :at=> 390
            stroke_horizontal_line 10, 530, :at=> 360
            stroke_horizontal_line 10, 530, :at=> 330
            stroke_horizontal_line 10, 530, :at=> 300
            stroke_horizontal_line 10, 530, :at=> 270
            stroke_horizontal_line 10, 530, :at=> 240
            stroke_horizontal_line 10, 530, :at=> 210
            stroke_horizontal_line 10, 530, :at=> 180
            stroke_horizontal_line 10, 530, :at=> 150
            
            # 振込先情報
            stroke_color "90ee90"
            stroke_horizontal_line 0, 540, :at=> 5
            stroke_horizontal_line 0, 540, :at=> 4    
            stroke_horizontal_line 0, 540, :at=> 3    
            stroke_horizontal_line 0, 540, :at=> 2    
            stroke_horizontal_line 0, 540, :at=> 1    
            stroke_horizontal_line 0, 540, :at=> 0    

            # 株式会社むすび情報
            draw_text "株式会社むすび", at: [330, 130], size: 14
            draw_text "〒577-0004", at: [330, 110], size: 12
            draw_text "大阪府東大阪市稲田新町二丁目14番7号", at: [330, 90], size: 12
            draw_text "TEL: 090-4360-9483", at: [330, 70], size: 12
            draw_text "FAX: 072-814-9831", at: [330, 50], size: 12
            image 'app/assets/images/むすび印.png', at: [460, 70], width: 70

        end
    end
end
