class Product < ApplicationRecord

    has_many_attached :images

    with_options presence: true do
        validates :product_name
        validates :price
        validates :description
        validates :stock
        validates :model_number
        validates :product_type
        validates :point
        validates :sales_profit
      end

    def was_attached?
        self.images.attached?
    end
    
end
