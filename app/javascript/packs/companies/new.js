// 会員規約に同意しないと登録できない
const companyRegistration = document.querySelector(".company_registration");
const isAgree = document.querySelector("#is_agree");

companyRegistration.addEventListener("click", (e) => {
  if (!isAgree.checked) {
    alert("会員規約に同意しなければ登録できません");
    e.preventDefault();
  }
});

