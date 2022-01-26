class IryosController < ApplicationController

  before_action :checked_auth, only: [:index]

  include IryosHelper

  def new
    @iryo = Iryo.new

    # 各都道府県ごとの市町村郡一覧
    @osaka_city = City.where(id: 1..43)
    @hyogo_city = City.where(id: 44..92)
    @kyoto_city = City.where(id: 93..124)
    @shiga_city = City.where(id: 125..146)
    @nara_city = City.where(id: 147..192)
    @wakayama_city = City.where(id: 193..228)
    @mie_city = City.where(id: 229..264)
    
    # 市ごとの区一覧
    # 大阪府
    @osaka_city_ward = Ward.where(id: 1..24)
    @sakai_city_ward = Ward.where(id: 25..31)
    # 兵庫県
    @kobe_city_ward = Ward.where(id: 32..40)
    # 京都府
    @kyoto_city_ward = Ward.where(id: 41..51)

  end

  def create
    @iryo = Iryo.new(iryo_params)
    @iryo.city_ids_slim

    if @iryo.valid?
      @iryo.save
      # slackへ通知を送る
      notifier = Slack::Notifier.new(ENV['WEBHOOK_URL'])
      notifier.ping "user:が作成されました。"
      
      # 登録した住所と、事業所の住所が一致する場合、事業者の担当者にメール
      # mail_to_gh("三重県", iryo_params, iryo_params[:city_id], "区がある市１", iryo_params[:ward_id], "区がある市２")区が無い場合はダミー
      # IryosHelper
      case @iryo.prefecture.name
        when "三重県" then
          mail_to_gh("三重県", iryo_params, iryo_params[:city_id], "ダミー", iryo_params[:ward_id], "ダミー")
        when "滋賀県" then
          mail_to_gh("滋賀県", iryo_params, iryo_params[:city_id], "ダミー", iryo_params[:ward_id], "ダミー")
        when "京都府" then
          mail_to_gh("京都府", iryo_params, iryo_params[:city_id], "京都市", iryo_params[:ward_id], "ダミー")
        when "大阪府" then
          mail_to_gh("大阪府", iryo_params, iryo_params[:city_id], "大阪市", iryo_params[:ward_id], "堺市")
        when "兵庫県" then
          mail_to_gh("兵庫県", iryo_params, iryo_params[:city_id], "神戸市", iryo_params[:ward_id], "ダミー")
        when "奈良県" then
          mail_to_gh("奈良県", iryo_params, iryo_params[:city_id], "ダミー", iryo_params[:ward_id], "ダミー")
        when "和歌山県" then
          mail_to_gh("和歌山県", iryo_params, iryo_params[:city_id], "ダミー", iryo_params[:ward_id], "ダミー")
      end

      redirect_to root_path, flash: {success: "登録が完了しました"}
    else
      render :new
    end

  end

  def index
    @search_params = iryo_search_params
    # @iryos_search = Iryo.search(@search_params).order(updated_at: :desc)
    
    @iryos = Iryo.all
    @iryos_search_pre = Iryo.search(@search_params).order(updated_at: :desc)
    
    @iryos.each do |iryo|
      @array = iryo.city_ids.split(",")
      @array.each do |city|
        if @search_params[:city_ids] == city
          if @iryos_search_pre.include?(iryo)
          else
            @iryos_search_pre += [iryo]
          end
        end
      end
    end
    @iryos_search = @iryos_search_pre
    # raise

    # 各都道府県ごとの市町村郡一覧
    @osaka_city = City.where(id: 1..43)
    @hyogo_city = City.where(id: 44..92)
    @kyoto_city = City.where(id: 93..124)
    @shiga_city = City.where(id: 125..146)
    @nara_city = City.where(id: 147..192)
    @wakayama_city = City.where(id: 193..228)
    @mie_city = City.where(id: 229..264)
    
  end

  def contact
  end

  private

  def iryo_params
    params.require(:iryo).permit(
      :age,
      :classification_id,
      :disability_type_id,
      :prefecture_id,
      :service_type_id,
      :sex_id,
      city_ids: [],
      ward_id: [],
    ).merge(user_id: current_user.id)
  end
  
  def iryo_search_params
    params.fetch(:search, {}).permit(
      :age_from,
      :age_to,
      :classification_id,
      :disability_type_id,
      :prefecture_id,
      :service_type_id,
      :sex_id,
      :city_ids,
      :ward_id,
    )
  end

  def checked_auth
    if company_signed_in?
    else
      redirect_to new_company_registration_path, flash: {success: "会員登録が必要です"}
    end
  end
  
end
