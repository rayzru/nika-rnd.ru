{include file="page-title.tpl" title="Заказ #`$orderNumber`"}



<div class="container">
	<div class="row">
		<div class="col-md-8">
			<table class="table">
				<thead>
				<tr>
					<th></th>
					<th>Наименование товара, артикул</th>
					<th>Количество</th>
					<th></th>
				</tr>
				</thead>
				<tbody>
				{section name="id" loop="$order"}
					<tr>
						<td>{$smarty.section.id.index_next}</td>
						<td>{$order[id].item_title} <span class="">{$order[id].item_key}</span></td>
						<td class="center">{$order[id].quantity} {$order[id].item_unit}</td>
						<td></td>
					</tr>
					{sectionelse}
					<tr>
						<td colspan="4" class="text-muted text-center">В заказе отсутствуют товары</td>
					</tr>
				{/section}
				</tbody>
			</table>
		</div>
		<div class="col-md-4">

			<span class='label label-{$order_statuses_labels[$orderData.order_status]}'>{$order_statuses[$orderData.order_status]}</span>

		</div>
	</div>
</div>
