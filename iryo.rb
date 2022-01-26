class Iryo < ApplicationRecord

  has_many :favorites, dependent: :destroy
  has_many :companies, through: :favorites, dependent: :destroy
  belongs_to :user


  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :prefecture
  belongs_to_active_hash :city
  belongs_to_active_hash :ward
  belongs_to_active_hash :service_type
  belongs_to_active_hash :disability_type
  belongs_to_active_hash :classification
  belongs_to_active_hash :sex

  with_options presence: true do
    validates :age, numericality: { only_integer: true, message: 'は半角英数字で入力して下さい'}
    validates :classification_id
    validates :disability_type_id
    validates :prefecture_id
    validates :city_ids
    validates :service_type_id
    validates :sex_id
  end

  # Iryoのcity_idsを配列で格納する → Iryoのcreateアクションで使用
  def city_ids_slim
    self.city_ids.gsub!(/[\[\]\"]/, "").gsub!(" ","") if attribute_present?("city_ids")
  end

  scope :search, -> (search_params) do
    return if search_params.blank?
    
    prefecture_id_is(search_params[:prefecture_id])
    .service_type_id_is(search_params[:service_type_id])
    .city_ids_like(search_params[:city_ids])
    .disability_type_id_is(search_params[:disability_type_id])
    .sex_id_is(search_params[:sex_id])
    .age_from(search_params[:age_from])
    .age_to(search_params[:age_to])

  end
  # 参考
  # モデル名.where('カラム名 like ?','%検索したい文字列%')文字列のどの部分にでも検索したい文字列が含まれていればOK
  # モデル名.where('カラム名 like ?','_検索したい文字列_')先頭と後方に一文字だけ何か文字が付いていて、検索したい文字列が中間にある場合。
  scope :prefecture_id_is, -> (prefecture_id) { where(prefecture_id: prefecture_id) if prefecture_id.present? }
  scope :city_ids_like, -> (city) { where('city_ids LIKE ?', "#{city}%") if city.present? }
  scope :service_type_id_is, -> (service_type_id) { where(service_type_id: service_type_id) if service_type_id.present? }
  scope :disability_type_id_is, -> (disability_type_id) { where(disability_type_id: disability_type_id) if disability_type_id.present? }
  scope :sex_id_is, -> (sex_id) { where(sex_id: sex_id) if sex_id.present? }
  scope :age_from, -> (from) { where('? <= age', from) if from.present? }
  scope :age_to, -> (to) { where('age <= ?', to) if to.present? }
  
end