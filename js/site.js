function plural_str(i, str1, str2, str3) {

	function plural(a) {
		if (a % 10 == 1 && a % 100 != 11) return 0;
		if (a % 10 >= 2 && a % 10 <= 4 && ( a % 100 < 10 || a % 100 >= 20)) return 1;
		return 2;
	}

	switch (plural(i)) {
		case 0: return str1;
		case 1: return str2;
		default: return str3;
	}
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


function getParameterByName(name) {
	name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
	var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
		results = regex.exec(location.search);
	return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}

function add2cart(id, qty) {
	qty = qty || 1;
	//$('.add2CartButton' + id).
	var single = typeof id == 'number';

	if (single) {
		var el = $('.add2CartButton' + id);
		$(el).button('loading');
	} else {

	}

	$.post("/my/add2CartAjax/", {id : id, qty: qty}, function(data) {
		if (data == 'error') {
			showNotify('Ошибка добавления товара в корзину', 'error');
		} else {
			//var num = 1;
			//showNotify(num + plural_str(num, ' товар добавлен',' товара добавлено',' товаров добавлено') + ' в корзину');
			showNotify("<h4>Добавлено</h4>Товар добавлен в корзину.<br/>Что бы ознакомится с товарами в вашей корзине,<br/>перейдите в <a href='/my/'>личный кабинет</a>.");
			updateCart();
		}
	}).always(function() {
		if (single) {
			$(el).button('reset');
		} else {
			$('.markedControls').animate({opacity: 0 }, 200, function() {});
			$('.itemWrapper').removeClass('marked');
			$('.itemMarkCheckbox:checked').prop("checked", false);
		}
	});
}

function removecart(id) {
	var el = $('.removeCartButton' + id);

	$(el).button('loading');
	$.post("/my/deleteCartItem/" + id, function(data) {
		if (data == 'error') {
			showNotify('Ошибка удаления товара в корзину', 'error');
		} else {
			$(el).remove();
		}
	});
}

function setCart(num) {
	$('#directCartLink').html('<i class="icon-cart"></i> В корзине ' + num + ' ' + plural_str(num, 'товар','товара','товаров'));
	$('.cartNum').text(num);
}

function updateCart() {
	$.ajax({
		url : "/my/getCartItems",
		type: "POST",
		dataType : "text",
		success: function(data) {
			if (data != 0) setCart(data);
		}
	});
}

$(function(){
    $('.bstooltip').tooltip();

	updateCart();

	$('.itemData .thumbnail a').click(function(e){
        $('#modalImage img').attr('src', $(this).attr('data-img-url'));
    });

	$('.ajaxAuth').on('submit', function(e){
		e.preventDefault();
		var form = this;
		$('.errormsg', form).remove();
		$('.ajaxAuthButton').button('loading');
		var data = $(form).serialize()
		$.post(form.action, data, function(response) {
			console.log('responce');
			if (response != 'ok') {
				if ($(form).not(':has(.errormsg)')) {
					$(form).prepend('<div class="style-msg errormsg"><div class="sb-msg"><i class="icon-remove"></i><strong>Ошибка авторизации!</strong><br/>Введены неверные логин или пароль. Попробуйте еще раз.</div></div>');
				}
			} else {
				location.reload();
			}
			$('.ajaxAuthButton').button('reset');
		});
	});


	$('.quantity .plus').click(function(e){
		e.preventDefault();
		fieldName = $(this).attr('rel');
		var currentVal = parseInt($('input[name='+fieldName+']').val());
		if (!isNaN(currentVal)) {
			$('input[name='+fieldName+']').val(currentVal + 1);
		} else {
			$('input[name='+fieldName+']').val(0);
		}
	});
	$(".quantity .minus").click(function(e) {
		e.preventDefault();
		fieldName = $(this).attr('rel');
		var currentVal = parseInt($('input[name='+fieldName+']').val());
		if (!isNaN(currentVal) && currentVal > 0) {
			$('input[name='+fieldName+']').val(currentVal - 1);
		} else {
			$('input[name='+fieldName+']').val(0);
		}
	});


});