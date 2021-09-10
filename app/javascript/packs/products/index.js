var $grid = $('.product_index_items'),   
    emptyCells = [],
    i;

// 子パネル (li.cell) の数だけ空の子パネル (li.cell.is-empty) を追加する。
for (i = 0; i < $grid.find('.product_index_item').length; i++) {
    emptyCells.push($('<li>', { class: 'cell is-empty' }));
}

$grid.append(emptyCells);