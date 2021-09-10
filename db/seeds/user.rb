User.create(agency_name: "代理店名", human_name: "代表者名", phone_number: "090-0000-1111", email: "yukiharu.nagao@icloud.com", postal_code: 1234567, address: "静岡県富士市青葉町", password: "1234aaaa", password_confirmation: "1234aaaa")

# 写真を入れるとき
# gh = Gh.find(1)
# gh.images.attach([io: File.open('app/assets/images/sazanka.png'), filename: 'sazanka.png'], [io: File.open('app/assets/images/koki.png'), filename: 'koki.png'])