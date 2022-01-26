module IryosHelper

  # チェックボックスがチェックされた状態で再renderされた時に、チェックを保持る
  def is_checked?(model, column, value)
    if params.dig(model, column)
      return params[model][column].include?(value.to_s)
    else
    end
  end
  
  # iryosで登録した住所と事業所の住所が一致するか判断。
  # 一致すれば、その事業所に通知を送る
  def mail_to_gh(prefecture_name, iryo_params, city_id, city_name_1, ward_id, city_name_2)
    
    gh_all = Gh.all

    gh_prefecture_name = prefecture_name

    # 複数チェックした市町村をひとつずつ展開
    iryo_params[:city_ids].each do |city_name|
      
      # 登録した住所の市の名前を取得 
      gh_city_name = city_name
      
      # 区がある市を選択した場合（例：大阪市を選択した場合）
      if gh_city_name == city_name_1
        # 複数チェックした区をひとつずつ展開 
        iryo_params[:ward_id].each do |ward_name|
          # 登録した住所の区の名前を取得 
          gh_ward_name = ward_name
          # 市区町村をまとめた名前
          registered_address = gh_prefecture_name + gh_city_name + gh_ward_name
          # まとめた名前と住所が一致するGHをgh_newに格納
          gh_new = gh_all.select do |i|
            i.address.include?(registered_address)
          end
          ContactMailer.iryo_gh_mail(gh_new, registered_address).deliver if gh_new.present?
        end
        # 区がある市を選択した場合（例：堺市を選択した場合）
      elsif gh_city_name == city_name_2
        iryo_params[:ward_id].each do |ward_name|
          gh_ward_name = ward_name
          registered_address = gh_prefecture_name + gh_city_name + gh_ward_name
          gh_new = gh_all.select do |i|
            i.address.include?(registered_address)
          end
          ContactMailer.iryo_gh_mail(gh_new, registered_address).deliver if gh_new.present?
        end
      # それ以外の市町村を選択した場合
      else
        registered_address = gh_prefecture_name + gh_city_name
        gh_new = gh_all.select do |i|
          i.address.include?(registered_address)
        end
        ContactMailer.iryo_gh_mail(gh_new, registered_address).deliver if gh_new.present?
      end
    end
  end
end
