{include file="page-title.tpl" title="Заказы"}

<section id="content" class="content-wrap">
	<div class="container">
		<div class="row">
			<div class="col-md-8">

				<ul id="portfolio-filter" class="clearfix">
					<li class="activeFilter"><a href="#" data-filter="all">Все заказы</a></li>
					<li><a href="#" data-filter=".order-added">{$order_statuses.added}</a></li>
					<li><a href="#" data-filter=".order-queued">{$order_statuses.queued}</a></li>
					<li><a href="#" data-filter=".order-rejected">{$order_statuses.rejected}</a></li>
					<li><a href="#" data-filter=".order-closed">{$order_statuses.closed}</a></li>
					<li><a href="#" data-filter=".order-deleted">{$order_statuses.deleted}</a></li>
				</ul>

				<div class="clear"></div>

				<div id="orders" class="faqs">

					{section name="id" loop="$orders"}
						{assign var="oc" value="`$orders[id].order_status`"}
						<div class="order order-{$orders[id].order_status}">
							<div class="fright">
								{if $orders[id].order_status == 'added'}
									<a href="/my/orders/?reject={$orders[id].order_id}&amp;status={$orders[id].order_status}" class="button button-border button-mini" title="Отметить заказ" onclick="return confirm('Вы действительно хотите отменить заказ?');"><i class="icon-remove"></i> Отменить</a>
								{/if}
								{if $orders[id].order_status == 'closed'}
									{* <a href="/my/orders/?delete={$orders[id].id}" class="ico ico-delete" title="Удалить заказ из списка" onclick="return confirm('Вы действительно хотите удалить заказ?');"></a> *}
								{/if}
								<a href="/my/orders/{$orders[id].order_id}" class="button button-border button-mini fright" title="Детализация заказа">Товары</a>
							</div>
							<h5>Заказ №{$orders[id].order_id} от {$orders[id].order_date|date_format:"%d.%m.%Y"}</h5>
							<p class="nomargin">
								В заказе {$orders[id].items_count} {$orders[id].items_count|plural:"товар":"товара":"товаров"}
								({$orders[id].all_items_count} {$orders[id].all_items_count|plural:"едкница":"едкницы":"едкниц"})
							</p>

						</div>
				{/section}
				</div>
			</div>
			<div class="col-md-4">
				<h4>Состояния заказов</h4>

				<dl class="dl-horizontal mini">
					<dt><span class="label label-success">{$order_statuses.added}</span></dt>
					<dd><p>Оформленные Вами заказы, которые поступают в обработку.</p></dd>

					<dt><span class="label label-info">{$order_statuses.queued}</span></dt>
					<dd><p>Подтвержденные заказы. Нами ведется оформление и комплектация заказа.</p></dd>

					<dt><span class="label label-warning">{$order_statuses.rejected}</span></dt>
					<dd><p>Отмененный заказ.</p></dd>

					<dt><span class="label label-default">{$order_statuses.closed}</span></dt>
					<dd><p>Выполненый и закрытый заказ.</p></dd>

					<dt><span class="label label-danger">{$order_statuses.deleted}</span></dt>
					<dd><p>Удаленный заказ.</p></dd>

				</dl>

			</div>
		</div>
	</div>
</section>
{literal}
<script type="text/javascript">
	jQuery(document).ready(function ($){
		var $faqItems = $('#orders .order');
		if( window.location.hash != '' ) {
			var getFaqFilterHash = window.location.hash;
			var hashFaqFilter = getFaqFilterHash.split('#');
			if( $faqItems.hasClass( hashFaqFilter[1] ) ) {
				$('#portfolio-filter li').removeClass('activeFilter');
				$( '[data-filter=".'+ hashFaqFilter[1] +'"]' ).parent('li').addClass('activeFilter');
				var hashFaqSelector = '.' + hashFaqFilter[1];
				$faqItems.css('display', 'none');
				if( hashFaqSelector != 'all' ) {
					$( hashFaqSelector ).fadeIn(500);
				} else {
					$faqItems.fadeIn(500);
				}
			}
		}

		$('#portfolio-filter a').click(function(){
			$('#portfolio-filter li').removeClass('activeFilter');
			$(this).parent('li').addClass('activeFilter');

			var faqSelector = $(this).attr('data-filter');
			$faqItems.css('display', 'none');
			if( faqSelector != 'all' ) {
				$( faqSelector ).fadeIn(500);
			} else {
				$faqItems.fadeIn(500);
			}
			return false;
		});
	});
</script>
{/literal}