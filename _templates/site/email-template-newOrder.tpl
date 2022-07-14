<h1>{$title}</h1>
<p>На сайте был сформирован заказ.</p>

<p>Ссылка на управление заказом в панели управления:<br/>
http://{$domain}/admin/orders/</p>

<b>Детализация заказа</b>
<ul>
{section loop=$orderItems name=id}
	<li><a href="http://{$domain}/catalog/viewItem/{$orderItems[id].item_id}">{$orderItems[id].item_title}</a> ({$orderItems[id].item_key}), {$orderItems[id].quantity} {$orderItems[id].item_unit}</li>
{/section}
</ul>

{if !empty($action)} <a class="btn-secondary" style="margin: 20px;" href="http://{$domain}{$action.url}">{$action.title} &raquo;</a>{/if}

<p style="font-style: italic; font-size: smaller;color: #777;">С уважением, ваш любимый робот {$domain}.</p>
