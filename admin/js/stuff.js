function addCategoryKeyword(keyword, id){
	$.ajax({
		url: '/admin/',
		type:  'POST',
		data: {
			'cid'		: id,
			'keyword'	:  keyword,
			'action'	: 'category_add_keyword' ,
			'mod'		: 'catalog'
		},
		success : function() {
			updateCategoryKeywords(id);
		}
	});
}

function getParameterByName(name) {
	name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
	var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
		results = regex.exec(location.search);
	return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}


function deleteCategoryKeyword(id, keyword) {
	$.ajax({
		url: '/admin/index.php',
		type: 'POST',
		data: {
			'cid'		: id,
			'keyword'	: keyword,
			'action'	: 'category_delete_keyword' ,
			'mod'		: 'catalog'
		},
		success : function(data, textStatus) {
			updateCategoryKeywords(id);
		}
	});
}

function updateCategoryKeywords(id) {
	$('#keywords_list').empty().addClass('loading');
	$('#keywords_list_editable').empty().addClass('loading');
	$.ajax({
		url: '/admin/index.php',
		dataType: 'json',
		data: {
			'cid'		: id,
			'action'	: 'category_get_keywords' ,
			'mod'		: 'catalog'
		},
		complete : function(data) {

		},
		success : function(data, textStatus) {
			// editable items
			$('#keywords_list').append('<b>Ключевые слова:</b> ');
			$.each(data.suggestions, function(i, item){
				var el = document.createElement('a');
				$(el).addClass('keyword').text(item).attr('title', 'Удалить ключевое слово');
				$(el).click(function(){
					if ( confirm('Удалить ключевое слово?')) deleteCategoryKeyword(id, item);
				});
				$('#keywords_list_editable').append(el);

				var el2 = document.createElement('span');
				$(el2).text(item);
				
				if (i != 0) $('#keywords_list').append(', ');
				$('#keywords_list').append(el2);
			});
			$('#keywords_list').removeClass('loading');
			$('#keywords_list_editable').removeClass('loading');
			// view items
		}
	});
}

$.easing.elasout = function(x, t, b, c, d) {
	var s=1.70158;var p=0;var a=c;
	if (t==0) return b;  if ((t/=d)==1) return b+c;  if (!p) p=d*.3;
	if (a < Math.abs(c)) { a=c; var s=p/4; }
	else var s = p/(2*Math.PI) * Math.asin (c/a);
	return a*Math.pow(2,-10*t) * Math.sin( (t*d-s)*(2*Math.PI)/p ) + c + b;
};


function getItemId() {
	return ($('#item_id').val() != '') ? parseInt($('#item_id').val()) : 0;
}


function addFeature() {
	$('#feature_id').val('');
	$('#feature_title').val('');
	$('#feature_unit').val('');
	$('#feature_form_title').text('Новое свойство');
	$('#action').val('feature_add');
}

function editContent(id) {
	$.ajax({
		url: '/admin/index.php',
		dataType: 'json',
		data: {
			'id'		: id,
			'action'	: 'content_get' ,
			'mod'		: 'content'
		},
		success : function(data) {
			$('#content_title').val(data.title);
			$('#content_label').val(data.label);
			$('#content_label_data').val(data.label);
			$('#content_id').val(data.id);
			$('#content_text').val(data.text);
		}
	});
	$('.edit_mode, .view_mode').toggle();

}

function editFeature(f_id, title, unit) {
	
	$('#feature_title').val(title);
	$('#feature_unit').val(unit);
	$('#feature_id').val(f_id);
	
	$('#feature_form_title').text('Изменение свойства');
	
	$('#action').val('feature_edit');
	
	$('.edit_mode, .view_mode').toggle();
	return false;
}


function cloneItemFeatures() {
	if ($('#cloneItemFeatures').val() == 0) {
		alert ('Выберите товар из списка для клонирования его характеристик');
		return false;
	}
	$.ajax({
		url: '/admin/index.php',
		dataType: 'json',
		context: document.body,
		data: {
			'clone_id'	: $('#cloneItemFeatures').val(),
			'item_id'	: $('#item_id').val(),
			'action'	: 'clone_features',
			'mod'		: 'catalog'
		},
		success : function(jsondata) {
			updateItemFeatures(jsondata.features);
		}
	});
}



function updateCloneItems(){
	cid = $('#category_id').val();
	$.ajax({
		url: '/admin/index.php',
		dataType: 'json',
		context: document.body,
		data: {
			'cid'		: cid,
			'action'	: 'itemsoptions',
			'mod'		: 'catalog'
		},
		success : function(jsondata) {
			$('#cloneItemFeatures').empty();
			$('#cloneItemFeatures').append('<option value="0" selected="selected"> -- выберите товар -- </option>');
			$(jsondata.items).each(function(el, i){
				$('#cloneItemFeatures').append('<option value="'  + this.item_id + '">' + this.item_title +'</option>');
			});
		}
	});


}

function updateItemFeatures(dataarray) {
	$('.feature_item_line').hide().remove();
	$("#features_empty").hide();
	var fTable = $('#features_table');
	if (dataarray != '') {
		var tr = $("#features_empty");
		var newline = '';
		$(dataarray).each(function(index, el){
			val = el.feature_value;
			val = val.replace('"', '\"');
			newline =
					"<tr class='feature_item_line'>" +
					"<td>" + el.feature_title + "</td>" +
					"<td><input type='text' class='featureinput' name='feature[" + el.feature_id +"]' value='" + val + "'> " + el.feature_unit + "</td>" +
					"<td><a href='#' class='button ico ico-delete' onclick=\"if (confirm('Подтвердите удаление свойтсва товара')) {deleteItemFeature(" + el.item_id + "," + el.feature_id + ");} return false;\"></a></td>" +
					"</tr>";
			fTable.append(newline);
		});
	}
	updateCloneItems();
}

function saveItemFeatures(){
	item_id = parseInt($('#item_id').val());
	if (!item_id) return false;
	$.ajax({
		url: '/admin/index.php',
		dataType: 'json',
		type: 'POST',
		data: {
			'action'	: 'save_item_features',
			'mod'		: 'catalog',
			'item_id'	: item_id,
			'features'  : $('input.featureinput').serializeArray()
		},
		success : function(data) {
			updateItemFeatures(data.features);
		}
	});

	return false;
}

function updateCategoryFeatures(dataarray) {
	$('.feature_item_line').hide().remove();
	$("#cat_features_empty").hide();
	var fTable = $('#cat_features_table');
	if (dataarray != '') {
		//var tr = $("#cat_features_empty");
		var newline = '';
		$(dataarray).each(function(index, el){
			newline =
					"<tr class='feature_item_line'>" +
					"<td>" + el.feature_title + "</td>" +
					"<td><a href='#' class='button ico ico-delete' onclick=\"if (confirm('Подтвердите удаление выделенного свойтсва')) {deleteCategoryFeature(" + el.cid + "," + el.feature_id + ");} return false;\"></a></td>" +
					"</tr>";
			fTable.append(newline);
		});
	}
}




function deleteItemImage(image_id) {
	$.ajax({
		url: '/admin/index.php',
		dataType: 'json',
		data: {
			'image_id'	: image_id,
			'action'	: 'delete_item_image',
			'mod'		: 'catalog'
		},
		success : function(data) {
			updateItemImages(data.images);
		}
	});
}

function deleteCategoryImage(cid) {
	$.ajax({
		url: '/admin/catalog/deleteCategoryImage/' + cid,
		success : function(data) {
			$('.categoryImage').text('Изображение удалено');
		}
	});
}


function updateItemImages(array) {
	$('.item_image').hide().remove();
	var Items = $('#itemimagesContainer');
	var star = '';
	var star_class = '';
	var newImage = "";
	if (array) {
		Items.empty();
		var newImage = '';
		$(array).each(function(index, el){
			star = (el.default_image == 'true') ? "" : "<a href='#' class='button ico ico-star' onclick=\"defaultItemImage(" + el.image_id + "); return false;\"></a>";
			star_class = (el.default_image == 'true') ? ' default' : '';
			newImage = "<div class='item_image'>" +
					"<div class='imageContainer"+ star_class+ "' style='background-image: url(/images/catalog/50x50/" + el.image_file + ");'></div>" +
					"<div class='clr pt5'></div>" +
					"<a href='#' class='button ico ico-delete' onclick=\"if (confirm('Подтвердите удаление изображения')) {deleteItemImage(" + el.image_id + ");} return false;\"></a>" +
					star +
					"</div>";
			Items.append(newImage);
		});
		Items.append("<div class='clr pb10'></div>");
	}
}


function setCategory(el) {

	title = $(el).text();
	elid = $(el).attr('id');
	id = elid.match(/\d+/)[0];
	$('#treeSelectorTrigger').text(title);
	$('#category_id').val(id);
	$('#treeSelector').hide('fast');
}

function category_selector(){
	$('#treeSelector').toggle();
	cid = $('#category_id').val();
	$('#treeSelector').scrollTo('#category_' + cid, 1000);
}

function editItem(id) {

	$('#content_area').mask({loadSpeed: 0});

	uploader.setParams({
		mod       : 'catalog',
		action    : 'item_image_upload',
		item_id   : id
	});

	$.ajax({
		url: '/admin/index.php',
		dataType: 'json',
		data: {
			'id'		: id,
			'action'	: 'item_get',
			'mod'		: 'catalog'
		},
		success : function(data) {
			item_title = data.item_title.replace(/&quot;/g, '"');
			item_title_alternative = data.item_title_alternative.replace(/&quot;/g, '"');

			$('#item_form_title').text('Изменение параметров товара');
			$('#item_id').val(data.item_id);
			$('#item_title').val(item_title);
			$('#item_alt_title').val(item_title_alternative);
			$('#item_unit').val(data.item_unit);
			$('#item_price').val(data.item_price);
			$('#item_active').val(data.item_active);

			if (data.item_new == 1) $('#item_new').attr('checked', 'checked');

			$('#item_availability').val(data.item_availability);

			$('#panel_items .advanced').show();
			$('#item_key').val(data.item_key);
			$('#item_description').val(data.item_description);
			if (data.show_image == 'true') {
				$('#item_show_image').attr("checked", "checked");
			}

			//$('.Itemqueue').attr('id', 'itemfileQueue' + data.item_id);
			
			// UPDATE UPLOAD SETTINGS HERE
			

			updateItemFeatures(data.features);
			updateItemImages(data.images);

			$.mask.close();
		}
	});
	$('#panel_items .edit_mode, #panel_items .view_mode').toggle();
}

function addItemFeature() {
	$.ajax({
		url: '/admin/index.php',
		dataType: 'json',
		data: {
			'action'	: 'add_item_feature' ,
			'mod'		: 'catalog',
			'feature_id': $('#select_feature_id').val(),
			'feature_value': $('#feature_value').val(),
			'item_id'   : $('#item_id').val()
		},
		success : function(data) {
			if (data) {
				updateItemFeatures(data.features);
				s = $('#select_feature_id')[0];
				$('#feature_value').val('');
				s.selectedIndex = 0;
			}
		}
	});

	return false;
}

function addCategoryFeature() {
	$.ajax({
		url: '/admin/index.php',
		dataType: 'json',
		data: {
			'action'	: 'add_category_feature' ,
			'mod'		: 'catalog',
			'feature_id' : $('#cat_select_feature_id').val(),
			'cid' : $('#cid').val()
		},
		success : function(data) {
			if (data) {
				updateCategoryFeatures(data.features);
				s = $('#cat_select_feature_id')[0];
				s.selectedIndex = 0;
			}
		}
	});

	return false;
}


function loadCategoryFeatures(cid) {
	$.ajax({
		url: '/admin/index.php',
		dataType: 'json',
		data: {
			'action'	: 'load_category_features' ,
			'mod'		: 'catalog',
			'cid' : $('#cid').val()
		},
		success : function(data) {
			if (data) {
				updateCategoryFeatures(data.features);
				s = $('#cat_select_feature_id')[0];
				s.selectedIndex = 0;
			}
		}
	});
	return false;
}

function deleteItemFeatures() {
	item_id = parseInt($('#item_id').val());
	if (!item_id) return false;
	$.ajax({
		url: '/admin/index.php',
		dataType: 'json',
		data: {
			'action'	: 'delete_item_features',
			'mod'		: 'catalog',
			'item_id'   : item_id
		},
		success : function(data) {
			updateItemFeatures(data.features);
		}
	});

	return false;
}

function loadCategoriesWOImages(){
    skip  = $('.catWOIMage').size();
    limit = 5;
    $.ajax({
		url: '/admin/index.php',
		dataType: 'json',
		data: {
			'action'	: 'getCategoriesWOImages',
			'mod'		: 'catalog',
			'skip'      :  skip,
			'limit'     : limit
		},
		success : function(data) {
			$(data).each(function(i, el){
				$('#categories_no_images').append("<li class='catWOIMage'><a href='/admin/?mod=catalog&cid=" + el.category_id + "'>" + el.category_title + "</a></li>");
			})
		}
	});

	return false;
}

function loadItemsWOImages(skip, limit){
    skip = $('.itemWOIMage').size();
    limit = 5;
    console.log(skip);
	$.ajax({
		url: '/admin/index.php',
		dataType: 'json',
		data: {
			'action'	: 'getItemsWOImages',
			'mod'		: 'catalog',
			'skip'      :  skip,
			'limit'     : limit
		},
		success : function(data) {
			$(data).each(function(i, el){
				$('#items_no_images').append("<li class='itemWOIMage'><a href='/admin/?mod=catalog&cid=" + el.category_id + "#items'>" + el.item_title + "</a></li>")
			})
		}
	});

	return false;
}

function deleteItemFeature(item, feature) {
	$.ajax({
		url: '/admin/index.php',
		dataType: 'json',
		data: {
			'action'	: 'delete_item_feature',
			'mod'		: 'catalog',
			'feature_id': feature,
			'item_id'   : item
		},
		success : function(data) {
			//console.log(data);
			updateItemFeatures(data.features);
			//$(data).each(function(el, i){ })
		}
	});

	return false;
}


function deleteCategoryFeature(category, feature) {
	$.ajax({
		url: '/admin/index.php',
		dataType: 'json',
		data: {
			'action'	: 'delete_category_feature',
			'mod'		: 'catalog',
			'feature_id': feature,
			'cid'   : category
		},
		success : function(data) {
			updateCategoryFeatures(data.features);
		}
	});

	return false;
}

function defaultItemImage(image) {
	$.ajax({
		url: '/admin/index.php',
		dataType: 'json',
		data: {
			'action'	: 'default_item_image',
			'mod'		: 'catalog',
			'image_id': image
		},
		success : function(data) {
			updateItemImages(data.images);
		}
	});

	return false;
}

function showNotify(text, type) {
	//	bootstrapGrowl
	type = type || 'success';
	$.bootstrapGrowl(text, {
		type: type,
		align: 'center',
		width: 'auto',
		allow_dismiss: true
	});
}


function initKeywordsFeature(){
	$('#new_keyword').autocomplete({
		serviceUrl: '/admin/',
		params: {
			action: 'list_keywords',
			mod: 'catalog',
			cid : '{/literal}{$cid}{literal}'
		},
		minChars: 2,
		maxHeight:400,
	    width:300,
		deferRequestBy: 400
	});

	$('#new_keyword_button').click(function(){
		if ($('#new_keyword').val().length > 1) addCategoryKeyword($('#new_keyword').val(), '{/literal}{$cid}{literal}');
		$('#new_keyword').val('');
		return false;
	});


	$('#new_keyword').keypress(function(event) {
		if ($('#new_keyword').val().length > 1) {
			if (event.keyCode == '13') {
				event.preventDefault();
				addCategoryKeyword($('#new_keyword').val(), '{/literal}{$cid}{literal}');
				$(this).val('');
			}
		}

	});
}

function proceedPrices2(filename) {
	$.ajax({
		url: '/admin/index.php',
		dataType: 'json',
		data: {
			'action'	: 'do_prices',
			'mod'		: 'other',
			'filename': filename
		},
		success : function(data) {
			if (data.success) {
				alert('Цены обновлены');
				$('#step2').empty();
				$('#step1').show();
			}
		}
	});
}

function proceedPrices(filename, data) {
	table = document.createElement('table');
	$(table).append("<thead><tr><th>Товар</th><th>Старая цена</th><th>Новая цена</th></tr></thead>");
	$(table).addClass('w100p list')
	$(data.items).each(function(index, el){
		$(table).append("<tr><td>" + el.item_title + "</td><td class='strikeout right'>" + el.price + "</td><td class='right'>" + el.newprice + "</td></tr>");
	});

	$('#step1').hide();
	$('#step2').append(table);
	$('#step2-2').append("<div class='mt10 center'><button type='button' onclick='proceedPrices2(\"" + data.filename + "\");'>Продолжить</button><button type='button' onclick=\"proceedCancel();\">Отмена</button></div>");
}

function proceedCancel() {
	$('#step2-2').empty();
	$('#step2').empty();
	$('#step3').hide();
	$('#step1').show();
}

function proceedNames2(filename) {
	$.ajax({
		url: '/admin/index.php',
		dataType: 'json',
		data: {
			'action'	: 'do_names',
			'mod'		: 'other',
			'filename': filename
		},
		success : function(data) {
			if (data.success) {
				alert('Наименования обновлены');
				proceedCancel();
			}
		}
	});
}


function parseArticuls() {
	articuls  = $('#articuls').val();
	$.ajax({
		url: '/admin/index.php',
		dataType: 'json',
		type: 'POST',
		data: {
			'articuls'	: articuls,
			'action'	: 'parsearticuls',
			'mod'		: 'other'
		},
		success : function(data, textStatus, obj) {
			var x = data;
			if (textStatus == 'success') {
				if (x.items.length > 0) {
					$('#items_ids').val(x.ids);
					table = document.createElement('table');
					$(table).append("<thead><tr><th>Товар</th></tr></thead>");
					$(table).addClass('w100p list');
					$(x.items).each(function(index, el){
						$(table).append("<tr><td>" + el.item_title + "</td></tr>");
					});
					$('#step1').hide();
					$('#step2').append(table);
					$('#step3').show();
				} else {
					alert ('Товары с указанными артикулами не найдены');
				}

			}

		}
	});
}

function proceedOperation(ids, operation) {
	$.ajax({
		url: '/admin/index.php',
		dataType: 'json',
		type: 'POST',
		data: {
			'articuls'	: ids,
			'operation'	: operation,
			'action'	: 'operatelist',
			'mod'		: 'other'
		},
		success : function(data) {
			if (data.success) {
				alert(data.message);
				proceedCancel();
			}
		}
	});
}

function proceedNames(filename, data) {
	table = document.createElement('table');
	$(table).append("<thead><tr><th>Товар</th><th>Новое наименование</th></tr></thead>");
	$(table).addClass('w100p list')
	$(data.items).each(function(index, el){
		$(table).append("<tr><td>" + el.item_title + "</td><td>" + el.newname + "</td></tr>");
	});

	$('#step1').hide();
	$('#step2').append(table);
	$('#step2-2').append("<div class='mt10 center'><button type='button' onclick='proceedNames2(\"" + data.filename + "\");'>Продолжить</button><button type='button' onclick=\"proceedCancel();\">Отмена</button></div>");
}


/* CATALOG AUTOLOAD FEATURES */

var uploader = '';
var uploaderCat = '';

var loading = function() {
	var over = '<div id="overlay"><img id="loading" src="/admin/images/ajax-loader.gif" width="24" height="24" border="0" /></div>';
	$(over).appendTo('body');
	$('#overlay').click(function() { $(this).remove(); });
	$(document).keyup(function(e) { if (e.which === 27)  $('#overlay').remove(); });
};