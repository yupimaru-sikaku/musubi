module PracticePdf
    class PostPdf < Prawn::Document
      def initialize
        super(page_size: 'A4') # 新規PDF作成
        stroke_axis # 座標を表示
      end
    end
  end