const buttonMinus = document.querySelector(".button_minus");
const buttonPlus = document.querySelector(".button_plus");
const textBox = document.querySelector(".textbox");

buttonMinus.addEventListener("click", (e) => {
  e.preventDefault();
  if (textBox.value > 1) {
    textBox.value--;
  }
});
buttonPlus.addEventListener("click", (e) => {
  e.preventDefault();
  textBox.value++;
});