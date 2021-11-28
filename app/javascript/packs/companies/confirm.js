// 会員規約に同意しないと登録できない
const companyRegistration = document.querySelector(".company_registration");
const companyProducts = document.querySelectorAll(".company_product");

let flag = false;

companyRegistration.addEventListener("click", (e) => {
  for (let i = 0; i < companyProducts.length; i++) {
    if (companyProducts[i].checked) {
      flag = true;
    }
  }

  if (!flag) {
    alert("購入する商品を選択して下さい");
    e.preventDefault();
  }
});
