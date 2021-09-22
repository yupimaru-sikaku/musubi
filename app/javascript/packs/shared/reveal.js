// フクシズのサイト内
document.addEventListener('DOMContentLoaded', () => {

  ScrollReveal().reveal('.home_index_img', {
    duration: 3200, 
    origin: 'top', 
    distance: '50px',
    reset: false   
  });
  
  ScrollReveal().reveal('.home_index_about', {
    duration: 3200, 
    origin: 'bottom', 
    distance: '50px',
    reset: false   
  });

  ScrollReveal().reveal('.home_index_activity', {
    duration: 3200, 
    origin: 'bottom', 
    distance: '50px',
    reset: false   
  });

});
