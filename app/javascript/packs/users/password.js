const passwordField = document.querySelector('#user_password')
const passwordConfirmationField = document.querySelector('#user_password_confirmation')
const editButton = document.querySelector('.edit_btn')

editButton.addEventListener('click', (e) => {
  const passwordText = passwordField.value
  const passwordConfirmationText = passwordConfirmationField.value
  
  if (passwordText !== ""){
    if ((passwordText.match(/^(?=.*?[a-z])(?=.*?\d)[a-z\d]{8,100}$/i) == null)){
      alert("パスワードは8桁以上の半角英数字にしてください。記号を含むことはできません。")
      e.preventDefault()
    }
  }


})