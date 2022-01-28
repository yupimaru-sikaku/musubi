User.create(human_name: "管理者", postal_code: "5610824", address: "大阪府豊中市大島町", phone_number: "09080647280", email: "yukiharu.nagao@icloud.com", agency_code: "master", password: "testtest1")
user = User.find(1)
user.update(encrypted_password: "$2a$12$pwh5AeosxDXyuTPbWvs8XeQr.KuaWZUaP46BkSsAF7491y/RBWV..")

User.create(human_name: "山口美枝", postal_code: "6300248", address: "奈良県生駒市喜里が丘3-5-11", phone_number: "09098846979", email: "tamaco.uni@gmail.com", agency_code: "", password: "testtest1")
user = User.find(2)
user.update(encrypted_password: "$2a$12$spII9aZV4fdk5VgFhYWoZOq6Q3LPbwHI2aF4JRcR0mynKEzKK6rx2")

User.create(human_name: "酒井　三和子", postal_code: "6048154", address: "京都府京都市中京区菊水鉾町573-1206", phone_number: "09027250086", email: "apriccoco@docomo.ne.jp", agency_code: "ONSkvDSp", password: "testtest1")
user = User.find(3)
user.update(encrypted_password: "$2a$12$NENY.vDQ7DEiCmZHNJqdDubgk9fpafwvvA99d0yfuIcExQUheMvo6")