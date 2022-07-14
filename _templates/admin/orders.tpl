{literal}
<style type="text/css">
.popover {max-width: 800px;}
.popover-content .table tbody { max-height: 100px; overflow-y: scroll;}
</style>
{/literal}


<ol class="breadcrumb">
	<li><a href="/admin">Главная</a></li>
	<li class="active">Заказы</li>
</ol>

<h1>Заказы</h1>

<div class="well well-sm">
	<div class="btn-group" data-toggle="buttons" id="statuses">
		<label class="btn btn-primary">
			<input type="checkbox"  name="status" value="added"> Новый
		</label>
		<label class="btn btn-primary">
			<input type="checkbox"  name="status" value="queued"> Принят
		</label>
		<label class="btn btn-primary">
			<input type="checkbox"  name="status" value="closed"> Закрыт
		</label>
		<label class="btn btn-primary">
			<input type="checkbox"  name="status" value="rejected"> Отменен
		</label>
		<label class="btn btn-primary">
			<input type="checkbox"  name="status" value="deleted"> Удален
		</label>
	</div>
</div>


<table class="table ordersTable">
	<thead>
	<tr>
		<th></th>
		<th>Дата</th>
		<th>Пользователь</th>
		<th>Позиций</th>
		<th>Товаров</th>
		<th>Статус</th>
		<th></th>
	</tr>
	</thead>
	{section name=id loop=$orders}
		{assign var="oc" value="`$orders[id].order_status`"}
		<tr class="{$orders[id].order_status}" rel="{$orders[id].order_id}">
			<td>{$orders[id].order_id}</td>
			<td data-order="{$orders[id].order_date}">{$orders[id].order_date|date_format:"%D"}</td>
			<td>{if $orders[id].user_name == ""}{$orders[id].user_login}{else}{$orders[id].user_login} - {$orders[id].user_name}<br/><small>{$orders[id].user_email} ({$orders[id].user_phone})</small>{/if}</td>
			<td>{$orders[id].items_count}</td>
			<td>{$orders[id].all_items_count}</td>
			<td><span class="order_status {$orders[id].order_status}">{$order_statuses.$oc}</span></td>
			<td class="text-right">
				<div class="pull-left">
					<a href="/admin/orders/details/{$orders[id].order_id}" class="btn btn-xs btn-default detailsButton" data-loading-text="<i class='fa fa-spin fa-refresh'></i>" title="Детализация заказа"><i class="fa fa-list"></i></a>
					<a href="/admin/orders/delete/{$orders[id].order_id}" class="btn btn-xs btn-default"  onclick="return confirm('Удалить заказ и товары заказа из базы данных? Данная операция безвозвратна, подтвердите.');"><i class="fa fa-times"></i></a>
				</div>

				{if $orders[id].order_status == 'added'}
					<a href="/admin/orders/accept/{$orders[id].order_id}" class="btn btn-xs btn-default" onclick="return confirm('Подтвердить текущий заказ?');">Подтвердить</a>
					<a href="/admin/orders/reject/{$orders[id].order_id}" class="btn btn-xs btn-default" onclick="return confirm('Отменить текущий заказ?');">Отменить</a>
				{/if}

				{if $orders[id].order_status == 'rejected'}
					<a href="/admin/orders/restore/{$orders[id].order_id}" class="btn btn-xs btn-default" onclick="return confirm('Заказ был отменен. Вы действительно хотите восстановить?');">Восстановить</a>
				{/if}

				{if $orders[id].order_status == 'queued'}
					<a href="/admin/orders/close/{$orders[id].order_id}" class="btn btn-xs btn-default" onclick="return confirm('Заказ был выполнен?');">Завершить</a>
				{/if}
			</td>
		</tr>
		{sectionelse}
		<tr>
			<td colspan="4" class="empty">Заявки не оформлялись</td>
		</tr>
	{/section}
</table>



<script type="text/javascript">
	{literal}

	function getParameterByName(name) {
		name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
		var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
				results = regex.exec(location.search);
		return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
	}

	$(function(){

		var statuses = getParameterByName('s').split(',');
		if (statuses != '') $(statuses).each(function(k,v){
			$('input[value=' + v + ']').attr('checked', 'checked').parent().addClass('active');
		});

		if (statuses == '') $('input[value="added"]').attr('checked', 'checked').parent().addClass('active');

		$('.detailsButton').popover({
			placement:'left',
			title: "Детализация",
			html: 'true',
			container: 'body',
			trigger: 'manual'
		});

		$('.detailsButton').click(function(e){
			var el = $(this);
			$(el).button('loading');
			$('.detailsButton').popover('hide');
			e.preventDefault();
			$.ajax(el.attr('href'), {
				dataType: "html"
			}).done(function(data) {
				var popover = el.data('bs.popover')
				popover.options.content =  data;
				el.popover('toggle');
				$(el).button('reset');
			});
		});

		$(document).click(function (e) {
			$('.detailsButton').each(function () {
				if (!$(this).is(e.target) && $(this).has(e.target).length === 0 && $('.popover').has(e.target).length === 0) {
					if ($(this).data('bs.popover').tip().hasClass('in')) {
						$(this).popover('toggle');
					}
					return;
				}
			});
		});

		$('#statuses :checkbox').change(function(){
			var s = $( "#statuses :checked" ).map(function() {return this.value; }).get().join();
			document.location.href="/admin/orders/?s=" + s;
		});
	});
	{/literal}
</script>
