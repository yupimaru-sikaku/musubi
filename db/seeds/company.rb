Company.create(agency_name: "管理者", agency_code: "master",  human_name: "永尾 享春", birth_day: "1992/03/11", postal_code: "5610824", address: "大阪府豊中市大島町", phone_number: "09080647280", email: "yukiharu.nagao@icloud.com", financial_facility_name: "無し", bank_branch_name: "無し", bank_account_type: "無し", bank_account_number: "無し", bank_account_holder: "無し", product_name: "無し", admin: true, is_buy: true, password: "testtest1")
company = Company.find(1)
company.update(agency_code: "master", encrypted_password: "$2a$12$Adnuib0fxRhJT4E9I87mV.dzd5t80vQuhU0WvYlbOE.bmKzBOLiGW")

Company.create(agency_name: "山川かおる", agency_code: "ONSkvDSp",  human_name: "山川 かおる", birth_day: "1958/9/16", postal_code: "5530004", address: "大阪府大阪市福島区玉川4丁目2-5-706", phone_number: "09091179607", email: "mamaetta15@gmail.com", financial_facility_name: "楽天銀行", bank_branch_name: "マンボ支店(228)", bank_account_type: "普通", bank_account_number: "4026589", bank_account_holder: "ヤマカワカオル", product_name: "1", admin: false, is_buy: true, password: "testtest1")
company = Company.find(2)
company.update(agency_code: "ONSkvDSp", encrypted_password: "$2a$12$SrvMWy0FlkIPYHq8nVtoqOIowhUOoICS..KtbvtU.hBr.6niA7kCy")
