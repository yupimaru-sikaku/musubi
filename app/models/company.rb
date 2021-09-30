class Company < ApplicationRecord

  has_many :points
  
  before_create :make_agency_code, :add_point
  
  with_options presence: true do
    validates :agency_name
    validates :human_name
    validates :birth_day
    validates :postal_code
    validates :address
    validates :phone_number
    validates :email
    validates :financial_facility_name
    validates :bank_branch_name
    validates :bank_account_type
    validates :bank_account_number
    validates :bank_account_holder
  end
  
  # invitation_code
  # 招待コードの代理店コードがあるか
  validate :check_invitation_code

  # postal_code
  # 半角数字のみ
  validates :postal_code, numericality: { only_integer: true, message: 'は半角数字（ハイフン無し）で入力して下さい' }
  
  # phone_numner
  # 半角数字のみ
  validates :phone_number, format: { with: /\A[0-9]+\z/, message: 'は半角数字で入力して下さい' }
  
  # agency_code
  # 一意性
  validates :agency_code, uniqueness: { case_sensitive: true }
  
  # email
  # 一意性
  validates :email, uniqueness: { case_sensitive: true }
  
  # password,password_confirmation
  # 8桁以上半角英数字混在
  validates :password, format: {with: /(?=.*[a-zA-Z])(?=.*\d)[a-zA-Z\d]{8,}/, message: 'は8桁以上の半角英数字で入力して下さい' }, on: [:create]
  # # password_comfirmationと同じか
  validates :password, confirmation: { message: 'がパスワードと一致していません'}
  
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, invite_for: 24.hours

  private

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

  # ランダムな8桁を生成
  def make_agency_code
    require 'securerandom'
    agency_code = p SecureRandom.alphanumeric(8)
    if Company.exists?(agency_code: agency_code)
      agency_code = p SecureRandom.alphanumeric(8)
      self.agency_code = agency_code
    else
      self.agency_code = agency_code
    end
  end

  # 招待した会社のコードが存在するか判断
  def check_invitation_code
    if self.invitation_code != ""
      if !Company.find_by(agency_code: self.invitation_code).present?
        errors.add(:invitation_code, "は存在しません。再度招待コードを確認下さい。")
      end
    end
  end
  
  # 招待した代理店のカラム（招待者数）に＋１する
  def add_point
    if self.invitation_code.present?
      company = Company.find_by(agency_code: self.invitation_code)
      if company.present?
        company[:invited_person_number] += 1
        company.update(invited_person_number: company[:invited_person_number])
      end
    end
  end

end

