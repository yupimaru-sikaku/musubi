// 住所自動入力
$(function(){
  $('#postal_code').on('change', (event) => {
    event.preventDefault();
    $.ajax({
      url: "//zipcloud.ibsnet.co.jp/api/search?zipcode=" + $('#postal_code').val(),
      dataType: 'jsonp',
    }).done((data) => {
      if (data.results) { 
        getData(data.results[0]);
      } else {
        alert('入力頂いた郵便番号に該当する住所が見つかりません');
      }
    }).fail((data) => {
      alert('通信に失敗しました');
    });
  });

  function getData(data) {
    $('#address').val(data.address1 + data.address2 + data.address3);
  }
});