class Order < ApplicationRecord

    has_many :order_details, dependent: :destroy

end
