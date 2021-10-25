Product.create(id: 1, product_name: '銀イオン詰替え用（6ppm）2L×10セット', price: 33500, description: "3種類の保湿剤を配合し、手に潤いを与えるだけでなく、さらさら・すべすべ感も与えます。有効成分として「ベンザルコニウム塩化物」使用。広範囲の微生物に対して短時間で効力を発揮します。手でつぶせる容器です。", stock: 0, model_number: "AG010", product_type: "消毒液", display: true)
product = Product.find(1)
product.images.attach([io: File.open('app/assets/images/6ppm×2L.png'), filename: '6ppm×2L.png'])
Product.create(id: 2, product_name: '銀イオン詰替え用（20ppm）2L×10セット', price: 38500, description: "1．ポンプはゆっくり押して、適量（500円玉程度）をお取りください。 2． およそ15秒間、両手にまんべんなく塗り広げてください。 3．アルコールが完全に揮発するまで両手をすり合わせてください。", stock: 1, model_number: "AG011", product_type: "消毒液", display: true)
product = Product.find(2)
product.images.attach([io: File.open('app/assets/images/20ppm×2L.png'), filename: '20ppm×2L.png'])
Product.create(id: 3, product_name: '銀イオン詰替え用（6ppm）20L', price: 28000, description: "エンベロープのあるウイルスはアルコール消毒剤が効きやすく、ノンエンベロープウイルスは一般的なアルコール消毒剤が効きにくい傾向。そのためアルコール手指消毒剤はノンエンベロープウイルスを含む広範囲のウイルスを除去できるものが有効的。", stock: 2, model_number: "AG012", product_type: "消毒液", display: true)
product = Product.find(3)
product.images.attach([io: File.open('app/assets/images/6ppm×20L.png'), filename: '6ppm×20L.png'])
Product.create(id: 4, product_name: '銀イオン詰替え用（20ppm）20L', price: 33000, description: "食塩より100倍以上も安全という経口性を持ち、赤ちゃんやペットのいる環境でも安心。（経口急性毒性推定値（ATE）検査済み） 無香料なのでマスクの除菌にも気軽に使えます。ウィルスや細菌を99.9%以上除菌。（専門機関による抗ウィルス性検査済み）", stock: 3, model_number: "AG013", product_type: "消毒液", display: true)
product = Product.find(4)
product.images.attach([io: File.open('app/assets/images/20ppm×20L.png'), filename: '20ppm×20L.png'])