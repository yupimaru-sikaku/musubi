class User < ApplicationRecord

  has_one :card, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable

  with_options presence: true do
    validates :human_name
    validates :postal_code
    validates :address
    validates :phone_number
    validates :email
  end

  # agency_code
  # Companyモデルに存在するか
  validate :check_agency_code

  # address
  # 都道府県から入力されているか
  validate :is_valid_prefectures

  # postal_code
  # 半角数字のみ
  validates :postal_code, numericality: { only_integer: true, message: 'は半角数字（ハイフン無し）で入力して下さい' }
  
  # phone_numner
  # 半角数字のみ
  validates :phone_number, format: { with: /\A[0-9]+\z/, message: 'は半角数字で入力して下さい' }

  # email
  # 一意性
  validates :email, uniqueness: { case_sensitive: true }
  
  # password,password_confirmation
  # 8桁以上半角英数字混在
  validates :password, format: {with: /(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z\d]{8,}/, message: 'は8桁以上の半角英数字で入力して下さい' }, on: [:create]
  # # password_comfirmationと同じか
  validates :password, confirmation: { message: 'がパスワードと一致していません'}

  def update_without_current_password(params, *options)
    params.delete(:current_password)

    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    result = update_attributes(params, *options)
    clean_up_passwords
    result
  end

  private

  def check_agency_code
    if self.agency_code != ""
      if !Company.find_by(agency_code: self.agency_code).present?
        errors.add(:agency_code, "は存在しません。再度代理店コードを確認下さい。")
      end
    end
  end
  
  def is_valid_prefectures
    unless ["北海道", "青森県", "秋田県", "岩手県", "宮城県", "山形県", "福島県", "茨城県", "栃木県", "群馬県", "埼玉県", "千葉県", "神奈川県", "東京都", "山梨県", "新潟県", "長野県", "富山県", "石川県", "福井県", "静岡県", "愛知県", "三重県", "岐阜県", "大阪府", "京都府", "滋賀県", "奈良県", "和歌山県", "兵庫県", "岡山県", "広島県", "山口県", "鳥取県", "島根県", "香川県", "徳島県", "愛媛県", "高知県", "福岡県", "佐賀県", "長崎県", "熊本県", "大分県", "宮崎県", "鹿児島県", "沖縄県"].any? { |t| address.include?(t) }
      errors.add(:address, "は都道府県から入力して下さい。")
    end
  end

      
end

