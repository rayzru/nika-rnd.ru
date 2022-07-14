<table class="table">
	<thead>
		<tr>
			<th>№</th>
			<th>Наименование товара</th>
			<th>Ед. Изм.</th>
			<th>Артикул</th>
			<th>Количество</th>
		</tr>
	</thead>
	<tbody>
		{section name="id" loop="$order_items"}
			<tr>
				<td>{$smarty.section.id.index + 1}</td>
				<td>{$order_items[id].item_title}</td>
				<td>{$order_items[id].item_unit}</td>
				<td>{$order_items[id].item_key}</td>
				<td>{$order_items[id].quantity}</td>
			</tr>
		{sectionelse}
			<tr>
				<td colspan="5" class="text-center text-muted">В заказе отсутствуют товары</td>
			</tr>
		{/section}
	</tbody>
</table>