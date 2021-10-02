class Contact < ApplicationRecord

    with_options presence: true do
        validates :human_name
        validates :furigana
        validates :email
        validates :contact_detail
      end

  # phone_numner
  # 半角数字のみ
  validates :phone_number, format: { with: /\A[0-9]+\z/, message: 'は半角数字で入力して下さい' }

end
