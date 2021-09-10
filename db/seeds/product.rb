Product.create(product_name: '銀イオン詰替え用（6ppm）2L', price: 3000, description: "3種類の保湿剤を配合し、手に潤いを与えるだけでなく、さらさら・すべすべ感も与えます。有効成分として「ベンザルコニウム塩化物」使用。広範囲の微生物に対して短時間で効力を発揮します。手でつぶせる容器です。", stock: 0, model_number: "AG010", product_type: "消毒液")
product = Product.find(1)
product.images.attach([io: File.open('app/assets/images/消毒液1_1.png'), filename: '消毒液1_1.png'], [io: File.open('app/assets/images/消毒液1_2.png'), filename: '消毒液1_2.png'])
Product.create(product_name: '銀イオン詰替え用（20ppm）2L', price: 5000, description: "1．ポンプはゆっくり押して、適量（500円玉程度）をお取りください。 2． およそ15秒間、両手にまんべんなく塗り広げてください。 3．アルコールが完全に揮発するまで両手をすり合わせてください。", stock: 1, model_number: "AG011", product_type: "消毒液")
product = Product.find(2)
product.images.attach([io: File.open('app/assets/images/消毒液2_1.png'), filename: '消毒液2_1.png'], [io: File.open('app/assets/images/消毒液2_2.png'), filename: '消毒液2_2.png'])
Product.create(product_name: '銀イオン詰替え用（6ppm）20L', price: 7000, description: "エンベロープのあるウイルスはアルコール消毒剤が効きやすく、ノンエンベロープウイルスは一般的なアルコール消毒剤が効きにくい傾向。そのためアルコール手指消毒剤はノンエンベロープウイルスを含む広範囲のウイルスを除去できるものが有効的。", stock: 2, model_number: "AG012", product_type: "消毒液")
product = Product.find(3)
product.images.attach([io: File.open('app/assets/images/消毒液3_1.png'), filename: '消毒液3_1.png'], [io: File.open('app/assets/images/消毒液3_2.png'), filename: '消毒液3_2.png'])
Product.create(product_name: '銀イオン詰替え用（20ppm）20L', price: 3350, description: "食塩より100倍以上も安全という経口性を持ち、赤ちゃんやペットのいる環境でも安心。（経口急性毒性推定値（ATE）検査済み） 無香料なのでマスクの除菌にも気軽に使えます。ウィルスや細菌を99.9%以上除菌。（専門機関による抗ウィルス性検査済み）", stock: 3, model_number: "AG013", product_type: "消毒液")
product = Product.find(4)
product.images.attach([io: File.open('app/assets/images/消毒液4_1.png'), filename: '消毒液4_1.png'], [io: File.open('app/assets/images/消毒液4_2.png'), filename: '消毒液4_2.png'])
Product.create(product_name: '銀イオン詰替え用（20ppm）0.2L', price: 3350, description: "「タッチフリーで衛生的」汚れた手でポンプに直接触る必要がなく、手をかざすだけで自動でアルコールがスプレーされるアルコールディスペンサーです。タッチフリーで、 衛生的に使用できます。そして予防のために、日頃のこまめなて手洗いを心がけましょう。", stock: 4, model_number: "----", product_type: "消毒液")
product = Product.find(5)
product.images.attach([io: File.open('app/assets/images/消毒液5_1.png'), filename: '消毒液5_1.png'], [io: File.open('app/assets/images/消毒液5_2.png'), filename: '消毒液5_2.png'])