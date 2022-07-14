{include file="page-title.tpl" title="Корзина" }

<section id="content" class="content-wrap">
	<div class="container">
		<form name="order" action="/my/makeOrder" method="post">

		<div class="col_two_third">

			{if (!empty($cart))}
				<div class="promo promo-border promo-mini">
					<table class="table" style="margin-bottom: 0;">
					<thead>
					<tr>
						<th></th>
						<th>Наименование товара</th>
						<th>Цена</th>
						<th>Количество</th>
						<th></th>
					</tr>
					</thead>
					<tbody>
					{section name="id" loop="$cart"}
						{if $cart[id].availability == "0"}
							{assign var="haveOrderedItems" value="1"}
						{/if}

						<tr>
							<td class="text-muted" >{$smarty.section.id.iteration}</td>
							<td><a href="/catalog/viewItem/{$cart[id].item_id}">{$cart[id].item_title}</a>
								 {if $cart[id].availability == "1"}<i title="товар имеется в наличии" style="color: #aaccaa" class="fa fa-check-circle"></i>{else}<i title="товар доступен под заказ" class="fa fa-exclamation-circle"></i>{/if}
								<div class="">{$cart[id].item_key}</div>
							</td>
							<td class="text-right">{if $cart[id].price != "0.00"}{$cart[id].price|string_format:"%d"}&nbsp;<abbr title="рублей">руб.</abbr>{else}{/if}</td>
							<td class="text-center" style="white-space: nowrap;"><input type="number" name="item[{$cart[id].item_id}]" class="center" style="width:30px;border: none; border-bottom: 1px solid #c0c0c0" value="{$cart[id].quantity}" />&nbsp;{$cart[id].item_unit}</td>
							<td class="text-center"><a class="icon-remove" href="/my/deleteCartItem/{$cart[id].item_id}" onclick="return confirm('Удалить позицию из корзины?');"></a></td>
						</tr>
					{/section}
					</tbody>
				</table>
				</div>
			{else}
				<p>
					В корзине нет товаров.<br/>
					Вы можете добавить сюда любые товары из <a href="/catalog/" class="">каталога</a> для дальнейшего оформления в заказ.
				</p>
			{/if}
		</div>
		<div class="col_one_third col_last">

			{if !empty($cart)}
				{if $smarty.section.id.total > 0}

						<button class="button button-desc button-3d nomargin" style="display: block; width: 100%;" type="submit" name="order"
									{if $haveOrderedItems == 1}
										onclick="{literal}if (confirm('Оформить заказ на товары в корзине?')){return confirm('В корзине есть товары, наличие которых не подтверждено. Вам требуется связаться с менеджерами для уточнения информации о сроках и возможности поставки указанного перечня товаров. Продолжить оформление заявки?')};"{/literal}
									{else}
										onclick="return confirm('Оформить заказ на товары в корзине?');"
									{/if}
						>
							<div>Оформить
							<span>{$cartItems} {$cartItems|plural:"товар":"товара":"товаров"} на сумму {$cartTotal|replace:".00":""} руб.</span>
							</div>
						</button>
				{/if}
			{/if}

			{if !empty($cart)}
			<button class="button noleftmargin topmargin-sm button-mini button-border" type="submit" name="recalc">
				Пересчитать
			</button>
			<a href="/my/clearCart" class="button noleftmargin topmargin-sm button-mini button-border" onclick="return confirm('Подтвердите очистку корзины');">Очистить корзину</a>
			<p class="topmargin-sm">После оформления заказа наши менеджеры свяжутся с вами по вопросам наличия заказанных товаров и сроках поставки.</p>
			{/if}
		</div>

		</form>

	</div>
</section>