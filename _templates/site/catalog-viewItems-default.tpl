{include file="searchbar.tpl"}

<div class="whiteBg">
	<div class="container">
		<h1 class="page-header">{$category.category_title}</h1>
	</div>
</div>

{if !empty($category.category_description)}
	<div class="container">
		{$category.category_description}
	</div>
{/if}

{include file="my-ajaxloginformWrapper.tpl"}

<div class="container">
    <div class="markedControls">


		<a href="#" class="btn btn-default btn-sm selectedClear">Очистить отметки</a>
		<a href="#" class="btn btn-default btn-sm" id="buttonCompare" data-trigger="hover" data-placement="bottom" data-loading-text="Загрузка данных...">Сравнить</a>
		<a href="#" class="btn btn-success btn-sm selectedCartButton">В корзину</a>
    </div>
	{section name=i loop=$items}
		<div class="col-md-3 col-sm-3 col-xs-2 col-lg-3">
			<div class="categoryItemWrapper itemWrapper item{$items[i].item_id}" data-item="{$items[i].item_id}">

				<div class="image" style="background-image: url(/images/catalog/250x250/{if $items[i].image_file != ''}{$items[i].image_file}{else}image_blank.jpg{/if})"></div>
				<h5><a href="/catalog/viewItem/{$items[i].item_id}/{$items[i].item_title|transliterate|escape|lower}">{$items[i].item_title}</a><div><small>{$items[i].item_key}</small></div></h5>
				{if $items[i].price > 0 && $items[i].availability != 2}<div class="itemPrice">{$items[i].price|number_format:2:".":""|replace:".00":''} <i class="fa fa-rub"></i></div>{/if}
				<div
						class="{if $items[i].availability == 0 || $items[i].availability == 2}itemNotAvail{else}itemAvail{/if}"
						title="{if $items[i].availability == 0}На данный момент данная позиция отсутствует на наших складах. Товар доступен для приобретения под заказ. Для более точных данных обратитесь к нашим менеджерам.{elseif $items[i].availability == 1}Товар имеется в наличии на наших складах.{elseif $items[i].availability == 2}Товар временно отсутствует у производителя{/if}">
					{if $items[i].availability == 0}Под заказ{elseif $items[i].availability == 1}В наличии{elseif $items[i].availability == 2}Временно отсутствует{/if}
				</div>

				<div class="itemControls">
					<div class="checkbox pull-left">
						<label>
							<input type="checkbox" value="" class="itemMarkCheckbox" title="Пометить товар" rel="{$items[i].item_id}">
							<span class="text-muted">Пометить</span>
						</label>
					</div>
					<button class="btn btn-success pull-right btn-xs add2CartButton add2CartButton{$items[i].item_id}"  data-loading-text="<i class='fa fa-spinner fa-spin fa-large'></i> Добавление..." {if ($user->logged)}onclick="add2cart({$items[i].item_id});"{else} data-toggle="modal" data-target="#authModal"{/if}>В корзину</button>
				</div>
			</div>
		</div>
	{/section}
</div>

<script type="text/javascript">
{literal}
$(function(){
	var marked;
	$('.itemMarkCheckbox').click(function(){
		if ($(this).is(":checked")) {
			$(this).parents('.itemWrapper').addClass('marked');
		} else {
			$(this).parents('.itemWrapper').removeClass('marked');
		}

		var itemsList = $('<ul/>').addClass('list-group').css('marginBottom', 0);
		$.each($('.itemMarkCheckbox:checked'), function(i, item) {
			var linkText = $('.item' + $(item).attr('rel') + ' h5 a').text();
			var li = $('<li/>')
					.addClass('list-group-item')
					.text(linkText)
					.appendTo(itemsList)
		});

		$('#buttonCompare').data('bs.popover').options.content = itemsList;

		if ($('.itemMarkCheckbox:checked').length > 0) {
			$('.markedControls').show();
			$('.markedControls').animate({opacity: 1 }, 200, function() {});
		} else  {
			$('.markedControls').animate({opacity: 0 }, 200, function() {
				$('.markedControls').hide();
		});
		}
	});

	$('#buttonCompare').click(function(e){
		$('#buttonCompare').button('loading');
		e.preventDefault();
		document.location.href = '/catalog/compareItems/' + $.map($('.itemMarkCheckbox:checked'), function(el) { return $(el).attr('rel');}).join(',');

	});

	$('.selectedCartButton').click(function(e){
		e.preventDefault();
		var items = new Array();
		$('.itemMarkCheckbox:checked').each(function(index, el){
			items[index] = $(el).attr('rel');
		});
		add2cart(items);
	});

	$('.selectedClear').click(function(e){
		e.preventDefault();
		$('.itemMarkCheckbox:checked').trigger('click');
	});

	$('#buttonCompare').popover({html: true});
});
{/literal}
</script>