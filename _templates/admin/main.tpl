<script type="text/javascript">{literal}
	function toggleCommItem(id) {
		$.ajax({
				url: '/admin/catalog/toggleCommissionItem/' + id,
				type: 'POST',
				success : function(data) {
					$('a[rel=' + id + ']').parents('tr').remove();
					//return data;
				}
			});
	}
	{/literal}</script>


<h1>Заказы</h1>

<div class="row">
	<div class="col-md-5">

		<div class="panel panel-default">
			<div class="panel-heading"><a href="/admin/orders">Новые заказы</a></div>
			<table class="table">
				<thead>
				<tr>
					<th>Номер</th>
					<th>Пользователь</th>
					<th></th>
				</tr>
				</thead>
				<tbody>
				{section name=id loop=$orders_added}
					{assign var="oc" value="`$orders_added[id].order_status`"}
					<tr>
						<td>№{$orders_added[id].order_id} <small>от {$orders_added[id].order_date|date_format:"%d %m %H:%M"}</small></td>
						<td><span class="glyphicon glyphicon-user"></span> {$orders_added[id].user_login}</td>
						<td>{$orders_added[id].items_count}/{$orders_added[id].all_items_count}</td>
					</tr>
					{sectionelse}
					<tr>
						<td colspan="3" class="">Добавленных заказов нет</td>
					</tr>
				{/section}
				</tbody>
			</table>
		</div>
	</div>
	<div class="col-md-3">
		<ul class="list-group">
			<a class="list-group-item active" href="/admin/orders">Заказы</a>
		{section name="id" loop="$orders_statuses_count"}
			{assign var="i" value="`$orders_statuses_count[id].order_status`"}
			<li class="list-group-item">
				<span class="badge">{$orders_statuses_count[id].cnt}</span>
				<a href="/admin/orders/?s={$orders_statuses_count[id].order_status}">{$order_statuses[$i]}</a>
			</li>
		{/section}
		</ul>
	</div>
	<div class="col-md-4">
		<div class="panel panel-default">
			<div class="panel-heading"><a href="/admin/users">Пользователи</a></div>
			<table class="table">
				<thead>
				<tr>
					<th>Логин</th>
					<th>Заргистрирован</th>
				</tr>
				</thead>
				<tbody>
				{section name=id loop=$users}
					<tr>
						<td><span class="glyphicon glyphicon-user"></span> {$users[id].login}</td>
						<td>{$users[id].registered_date|date_format:"%d %m %Y"}</td>
					</tr>
					{sectionelse}
					<tr>
						<td colspan="2" class="empty">Пользователи не зарегистрированы</td>
					</tr>
				{/section}
				</tbody>
			</table>
		</div>
	</div>
</div>

<div class="row">
	<div class="col-md-6">
		<div class="panel panel-default">
			<div class="panel-heading">
				<h3 class="panel-title">Новинки</h3>
			</div>
			<div class="panel-body">
				<table class="table table-striped table-hover">
					<tbody>
					{section name="id" loop="$new"}
						<tr>
							<td>{$new[id].item_title}</td>
							<td><a href="/admin/catalog/deleteNewItem/{$new[id].item_id}" class="btn btn-default btn-xs pull-right" role="button">Удалить</a></td>
						</tr>
						{sectionelse}
						<tr>
							<td class="text-center text-muted">Новинки отсутствуют</td>
						</tr>
					{/section}
					</tbody>
				</table>
			</div>
		</div>
	</div>
	<div class="col-md-6">
		<div class="panel panel-default">
			<div class="panel-heading">
				<h3 class="panel-title">Коммиссионные товары</h3>
			</div>
			<div class="panel-body">
				<table class="table table-striped table-hover">
					<tbody>
					{foreach key=id from=$comm item=children}
						{foreach name=i from=$children.children item=item}
							<tr>
								<td>{$item.item_title}</td>
								<td><a href="#" rel="{$item.item_id}" class="btn btn-default btn-xs pull-right" role="button" onclick="toggleCommItem({$item.item_id});return false;">Удалить</a></td>
							</tr>
						{/foreach}
					{/foreach}
					</tbody>
				</table>
			</div>
		</div>
	</div>
</div>

<!--div class="row">
	<div class="col-md-4">

		<div class="panel panel-default">
			<div class="panel-heading">Разделы без изображений</div>

			<table class="table">
				<tbody>
				{section name="id" loop="$categoriesWOImages"}
					<tr>
						<td><a href="/admin/catalog/editCategory/{$categoriesWOImages[id].category_id}">{$categoriesWOImages[id].category_title}</a></td>
					</tr>
				{/section}
				</tbody>

			</table>
			<div class="panel-footer">
				<a href="#" class="pt10" onclick="loadCategoriesWOImages();return false;">показать еще</a>
			</div>
		</div>
	</div>
	<div class="col-md-4">
		<div class="panel panel-default">
			<div class="panel-heading">Товары без изображений</div>

			<table class="table">
				<tbody>
				{section name="id" loop="$itemsWOImages"}
					<tr>
						<td><a href="/admin/catalog/editItem/{$itemsWOImages[id].item_id}">{$itemsWOImages[id].item_title}</a></td>
					</tr>
				{/section}
				</tbody>

			</table>
			<div class="panel-footer">
				<a href="#" class="pt10" onclick="loadItemsWOImages();return false;">показать еще</a>
			</div>
		</div>
	</div>
</div-->
