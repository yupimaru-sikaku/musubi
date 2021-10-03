$(function () {
  $(".product_hamburger").click(function () {
    $(this).toggleClass("active");

    if ($(this).hasClass("active")) {
      $(".product_globalMenuSp").addClass("active");
    } else {
      $(".product_globalMenuSp").removeClass("active");
    }
  });
});
