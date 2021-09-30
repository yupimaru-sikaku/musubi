const { data } = require("jquery");

if(document.URL.match( /new/ ) || document.URL.match( /edit/ )){
  
  document.addEventListener('DOMContentLoaded', function(){
    const fileField = document.querySelector('#product_image');
    const imageLists = document.querySelector('.image-lists');
    const dataBox = new DataTransfer();
    const inputLabel = document.querySelector('.product_image_label');
    
    fileField.addEventListener('change', (e) =>{
      file = e.target.files[0];
      blob = window.URL.createObjectURL(file);
      dataBox.items.add(file);

      fileField.files = dataBox.files


      if (fileField.files.length == 6){
        inputLabel.style.display = 'none';
      }
      
      const blobDiv = document.createElement('div');
      blobDiv.setAttribute('class', 'image-list');
      
      const blobImage = document.createElement('img');
      blobImage.setAttribute('src', blob);
      blobImage.setAttribute('id', file.name);
      
      const deleteButton = document.createElement('p')
      deleteButton.setAttribute('class', 'delete');
      deleteButton.innerHTML = '削除';
      
      blobDiv.appendChild(blobImage);
      blobDiv.appendChild(deleteButton);
      imageLists.appendChild(blobDiv);
      
      
      
      deleteButton.addEventListener('click', function(){
        const deleteDiv = deleteButton.parentNode;
        const deleteImg = deleteButton.previousElementSibling;
        
        
        if (fileField.files.length == 1){
          deleteDiv.remove();
          fileField.value = "";
          dataBox.clearData();
          
        }else{
          
          Array.from(fileField.files).forEach(function(files, i){
            if (files.name == deleteImg.id){
              dataBox.items.remove(i);
              fileField.files = dataBox.files
            }
          });
        }
        deleteDiv.remove();

        if (fileField.files.length < 6){
          inputLabel.style.display = 'block';
        }
      })
    })
    
    
    
  });
}