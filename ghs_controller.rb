class GhsController < ApplicationController

  def new
    if company_signed_in?
      @gh = Gh.new
    else
      redirect_to new_company_registration_path, flash: {success: "事業所を登録するには会員登録が必要です"}
    end
  end
  
  def create
    @gh = Gh.new(gh_params)

    if @gh.valid?
      @gh.save
      redirect_to index_all_companies_path, flash: {success: "登録が完了しました"}
    else
      render :new
    end
    
  end

  def edit
    @gh = Gh.find(params[:id])
  end
  
  def update
    @gh = Gh.find(params[:id])

    if params[:gh][:image_ids]
      params[:gh][:image_ids].each do |image_id|
        image = @gh.images.find(image_id)
        image.purge
      end
    end

    if @gh.valid?
      @gh.update(gh_params)
      redirect_to index_all_companies_path, flash: {success: "編集が完了しました"}
    else
      render :edit
    end
  end

  def destroy
    @gh = Gh.find(params[:id])
    if @gh.company_id == current_company.id
      @gh.destroy
      redirect_to index_all_companies_path
    end
  end

  def show
    @gh = Gh.find(params[:id])
  end

  def lists_company_ghs
    ghs = current_company.ghs.pluck(:company_id)
    @ghs = Gh.find(ghs)
  end

  def downloadpdf
    @gh=Gh.find(params[:id])
    filepath = Rails.root.join('storage',@gh.images)
    stat = File::stat(filepath)
    send_file(filepath, :filename => @gh.filename, :length => stat.size)
  end

  private


  def gh_params
    params.require(:gh).permit(
      :main_company_name,
      :sub_company_name,
      :postal_code,
      :address,
      :phone_number,
      :fax_number,
      :email,
      :price_main,
      :price_sub1,
      :price_sub_cost1,
      :price_sub2,
      :price_sub_cost2,
      :price_sub3,
      :price_sub_cost3,
      :price_sub4,
      :price_sub_cost4,
      :price_sub5,
      :price_sub_cost5,
      :construction_year,
      :construction_month,
      :designated_year,
      :designated_month,
      :human_name,
      :human_phone_number,
      :human_email,
      :hp_url,
      :capacity,
      :availability,
      :station,
      :from_station,
      :residential_style,
      :residential_style_other,
      :staff_weekdaytime,
      :staff_weekdaytime_other,
      :barrier_free,
      :barrier_free_other,
      :valid_disability_other,
      gender: [],
      disability: [],
      valid_disability: [],
      staff_holidaytime: [],
      images: []
    ).merge(
      company_id: current_company.id
    )
  end
end
