
<table class="table table-hover" id="iT">
	<thead>
	<tr class="nodrag">
		<th><a href="/admin/catalog/sortItems/{$category.category_id}/title" title="Упорядочить список товаров по наименованию" onclick="return confirm('Вы действительно хотите изменить порядок вывода товаров в текущем разделе?');"><i class="glyphicon glyphicon-sort-by-alphabet" title="" style=""></i> Наименование товара</a></th>
		<th><a href="/admin/catalog/sortItems/{$category.category_id}/articul" title="Упорядочить список товаров по артикулу"  onclick="return confirm('Вы действительно хотите изменить порядок вывода товаров в текущем разделе?');"><i class="glyphicon glyphicon-sort" title="" style=""></i> Артикул</th>
		<th>Цена</th>
		<th><i class="glyphicon glyphicon-shopping-cart" title="Доступно для покупки" style=""></i></th>
		<th></th>
	</tr>
	</thead>
	<tbody>
	{section name=i loop=$items}
		<tr class="itemrow" id="item{$items[i].item_id}" {if $items[i].active == 0}style="background-color:#efefef;"{/if}>
			<td><a href="/admin/catalog/editItem/{$items[i].item_id}">{$items[i].item_title}</td>
			<td>{$items[i].item_key}</td>
			<td style="text-align: right;">{if $items[i].price != "0.00"}{$items[i].price|string_format:"%d"}&nbsp;р.{else}{/if}</td>
			<td>{if $items[i].availability == 1}<i class="glyphicon glyphicon-shopping-cart" title="Доступно для покупки" style="opacity: 0.4"></i>{/if}</td>
			<td class="">
				<a class="btn btn-xs btn-default" href="/admin/catalog/editItem/{$items[i].item_id}" title="Изменить товар" onclick=""><i class="glyphicon glyphicon-edit"></i></a>
				<a class="btn btn-xs btn-default" href="/admin/catalog/itemDelete/{$items[i].item_id}" title="Удалить товар" onclick="return confirm('Действительно хотите удалить товар?');"><i class="glyphicon glyphicon-remove"></i></a>
			</td>
		</tr>
		{sectionelse}
		<tr class="nodrag"><td colspan="5" class="text-muted">Товары отсутствуют в разделе</td></tr>
	{/section}
	</tbody>
</table>

{literal}
	<script type="text/javascript">
		$(function(){
			$("#iT").tableDnD({
				onDragClass: 'tableRowDragging',
				onDrop: function(table, row){
					$.ajax({
						url: '/admin/catalog/itemsSaveOrder',
						dataType: 'json',
						data: $.tableDnD.serialize(),
						success : function(data) {}
					});
				},
				serializeRegexp: /(\d+)/
			});
		});
	</script>
{/literal}
