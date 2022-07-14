<h1>{$title}</h1>
<h2>Уважаемый(ая) {$name}!</h2>
<p>Это письмо заказано вами на сайте {$domain} системой восстановления пароля.</p>

<p>Учтивый робот подготовил для Вас временный пароль, который вы можете изменить на любой, какой вы только пожелаете, как только окажетесь в личном кабинете.<br/>

<p style="background-color: #efefef;">
	<div>Логин: <b>{$email}</b></div>
	<div>Пароль: <b>{$password}</b></div>
</p>
{if !empty($action)} <a class="btn-secondary" style="margin: 20px;" href="http://{$domain}{$action.url}">{$action.title} &raquo;</a>{/if}

<p style="font-style: italic; font-size: smaller;color: #777;">С уважением, ваш любимый робот {$domain}.</p>
