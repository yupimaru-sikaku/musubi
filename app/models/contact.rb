class Contact < ApplicationRecord

    with_options presence: true do
        validates :human_name
        validates :furigana
        validates :email
        validates :contact_detail
      end

end
