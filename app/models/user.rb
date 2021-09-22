class User < ApplicationRecord

  has_many :orders;

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable

  with_options presence: true do
    validates :human_name
    validates :postal_code
    validates :address
    validates :phone_number
    validates :email
  end

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
      
end

