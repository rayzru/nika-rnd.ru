{include file="page-title.tpl" title=$category.category_title }

<div class="container clearfix">
	<div class="postcontent">
		<div id="shop" class="clearfix product-4 topmargin-sm">

			<table class="table">
				<thead>
					<tr>
						<th></th>
						<th>Наименование</th>
						<th>Артикул</th>
						<th>Наличие</th>
						<th>Цена</th>
						<th></th>
					</tr>
				</thead>
				<tbody>
				{section name=i loop=$items}
					<tr class="product-list product{$items[i].item_id}" rel="{$items[i].item_id}">
						<td>
							<a href="#" class="item-check-trigger"><i class="icon-check-empty"></i></a>
						</td>
						<td>
							<h4 class="nobottommargin"><a href="/catalog/viewItem/{$items[i].item_id}/{$items[i].item_title|transliterate|escape|lower}">{$items[i].item_title}</a></h4>
						</td>
						<td>
							<div class="text-muted">{$items[i].item_key}</div>
						</td>
						<td>
							<div
									class="avail-badge2 {if $items[i].availability == 0}order{elseif $items[i].availability == 1}ok{else}none{/if}"
									data-toggle="tooltip"
									title="{if $items[i].availability == 0}На данный момент данная позиция отсутствует на наших складах. Товар доступен для приобретения под заказ. {if $items[i].arrives_in == 2}Срок выполнения заказа 1-2 дня.{elseif $items[i].arrives_in == 5}Срок выполнения заказа 5 дней.{elseif $items[i].arrives_in == 7}Срок выполнения заказа - неделя.{elseif $items[i].arrives_in == 14}Срок выполнения заказа 2 недели.{elseif $items[i].arrives_in == 30}Срок выполнения заказа 1 месяц.{elseif $items[i].arrives_in == 60}Срок выполнения заказа 2 месяца.{else}Для более точных данных обратитесь к нашим менеджерам.{/if}{elseif $items[i].availability == 1}Товар имеется в наличии на наших складах.{elseif $items[i].availability == 2}Товар временно отсутствует у производителя{/if}">
								{if $items[i].availability == 0}Под заказ{if $items[i].arrives_in == 2} - 1-2 д.{elseif $items[i].arrives_in == 5} - 5 дн.{elseif $items[i].arrives_in == 7} - 1 нед.{elseif $items[i].arrives_in == 14} - 2 нед.{elseif $items[i].arrives_in == 30} - 1 мес.{elseif $items[i].arrives_in == 60} - 2 мес.{else}.{/if}{elseif $items[i].availability == 1}В наличии{elseif $items[i].availability == 2}Временно отсутствует{/if}
							</div>
						</td>
						<td>
							{if $items[i].price > 0 && $items[i].availability != 2}<div class="product-price">{$items[i].price|number_format:2:".":""|replace:".00":''} руб.</div>{/if}
						</td>
						<td>
							<a href="#" class="add-to-cart add2CartButton button button-mini add2CartButton{$items[i].item_id}" data-loading-text="<i class='fa fa-spinner fa-spin fa-large'></i> Добавление..." {if ($user->logged)}onclick="add2cart({$items[i].item_id});"{else} data-toggle="modal" data-target="#authModal"{/if}><i class="icon-shopping-cart"></i><span></span></a>
						</td>
					</tr>
			{sectionelse}
				<tr class="product{$items[i].item_id}" rel="{$items[i].item_id}">
					<td>
						<p>В текущем разделе товары не найдены</p>
					</td>
				</tr>
			{/section}
				</tbody>
			</table>


		</div>


	</div>

	<div class="sidebar col_last">

		<div class="clearfix topmargin-sm bottommargin-lg markedControls">

			<div class="sidebar-widgets-wrap">
				<div class="widget widget_links clearfix">

					<h4>Выбранные</h4>

					<a href="#" class="button button-green  {if ($user->logged)}selectedCartButton{/if}" {if (!$user->logged)}data-toggle="modal" data-target="#authModal"{/if}><i class="icon-cart"></i><span>В корзину</span></a>

					<!--a href="#" class="button button-white button-mini button-light selectedClear" id="buttonCompare" data-loading-text="Загрузка данных..."><i class="icon-signal"></i><span>Сравнить</span></a-->

					<ul id="selectedItems"></ul>

					<a href="#" class="selectedClear"> Очистить список</a>
				</div>
			</div>



		</div>

		{if !empty($category.category_description)}
			<p>{$category.category_description}</p>
		{/if}

	</div>

</div>
<script type="text/javascript">
{literal}
$(function(){
	//$('.commissionItem').popover();

	var marked;

	$('.item-check-trigger').click(function(e){

		e.preventDefault();
		console.log(1);

		if ($(this).parents('.product-list').hasClass('marked')) {
			$(this).parents('.product-list').removeClass('marked');
			$(this).find('i')[0].className = 'icon-check-empty';
		} else {
			$(this).parents('.product-list').addClass('marked');
			$(this).find('i')[0].className = 'icon-check';
		}

		var itemsList = $('#selectedItems').empty();
		$.each($('.product-list.marked'), function(i, item) {
			var linkText = $('.product' + $(item).attr('rel') + ' h4 a').text();
			var li = $('<li/>').append('<a href="#">' + linkText + '</a>').appendTo(itemsList);
		});


		if ($('.product-list.marked').length > 0) {
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
		document.location.href = '/catalog/compareItems/' + $.map($('.product.marked'), function(el) { return $(el).attr('rel');}).join(',');

	});

	$('.selectedCartButton').click(function(e){
		e.preventDefault();
		var items = new Array();
		$('.product.marked').each(function(index, el){
			items[index] = $(el).attr('rel');
		});
		add2cart(items);
	});

	$('.selectedClear').click(function(e){
		e.preventDefault();
		$('.product-list.marked .item-check-trigger').trigger('click');
	});

});
{/literal}
</script>