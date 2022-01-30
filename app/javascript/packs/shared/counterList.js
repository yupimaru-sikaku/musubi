const buttonMinus = document.querySelectorAll(".button_minus");
const buttonPlus = document.querySelectorAll(".button_plus");
const textBox = document.querySelectorAll(".textbox");

[...buttonMinus].forEach((minus, i) => {
  buttonMinus[i].addEventListener("click", (e) => {
    e.preventDefault();
    if (textBox[i].value > 1) {
      textBox[i].value--;
    }
  });
  buttonPlus[i].addEventListener("click", (e) => {
    e.preventDefault();
    textBox[i].value++;
  });
});
