<h1>{$title}</h1>
<h2>Уважаемый(ая) {$name}!</h2>
<p>Это письмо заказано вами на сайте {$domain} системой восстановления пароля.</p>

<p>Если вы не проходили процесс восстановления, можете смело удалять данное письмо.</p>

<p>Активация может быть закончена после того, как вы пройдете ссылке<br/>
http://{$domain}/my/activate/{$key}</p>

{if !empty($action)} <a class="btn-secondary" style="margin: 20px;" href="http://{$domain}{$action.url}">{$action.title} &raquo;</a>{/if}


<p style="font-style: italic; font-size: smaller;color: #777;">С уважением, ваш любимый робот {$domain}.</p>
