class Order < ApplicationRecord

    has_many :order_details, dependent: :destroy
    has_many :commitions, dependent: :destroy

end
