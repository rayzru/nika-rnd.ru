<table class="list mt10">
<thead>
<tr>
	<th class="w100">Дата</th>
	<th class="w50">Статус</th>
	<th class="w100">Пользователь</th>
	<th class="">Вопрос</th>
	<th class="w100"></th>

</tr>
</thead>
	<tr>
		<td colspan="5">
			<div class="floatr mt5">
				<a class="ico ico-delete button" href="/admin/?mod=qa&action=purge" onclick="return confirm('Подтвердите полное уничтожение всех вопросов помеченных на удаление.')">Очистить от удаленных</a>
			</div>

		{section name=pages loop=$qap}
			<a href="?mod=qa&p={$smarty.section.pages.iteration}" class="pageNo {if $qapc == $smarty.section.pages.iteration}current{/if}">{$smarty.section.pages.iteration}</a>
		{/section}
		</td>
	</tr>
{section name=id loop=$qa}
	<tr {if $qa[id].active == 0} class="rejected" {/if}>
		<td>{$qa[id].published_date|date_format}</td>
		<td>
			<span class="qa_status {$qa[id].status}">
				{if $qa[id].status == "new"}Новый
				{elseif $qa[id].status == "suspended"}Отложен
				{elseif $qa[id].status == "approved"}Ok
				{elseif $qa[id].status == "deleted"}Удален{/if}
			</span>
		</td>
		<td>
			<b>{$qa[id].name}</b>
			{if $qa[id].email!=''}<br/><a href="mailto:{$qa[id].email}">{$qa[id].email}</a>{/if}
			<br/>{$qa[id].address}
		</td>
		<td><b>{$qa[id].title}</b><br/>{$qa[id].question}</td>
		<td>
			{if $qa[id].status == "new"}
				<a href="/admin/?mod=qa&action=update&id={$qa[id].id}" class="ico ico-edit button" title="Изменить"></a>
				<a href="/admin/?mod=qa&action=suspend&id={$qa[id].id}" class="ico ico-no button" title="Отложить вопрос"></a>
				<a href="/admin/?mod=qa&action=delete&id={$qa[id].id}" class="ico ico-delete button" title="Удалить вопрос"></a>
			{elseif $qa[id].status == "suspended"}
				<a href="/admin/?mod=qa&action=update&id={$qa[id].id}" class="ico ico-edit button" title="Изменить"></a>
				<a href="/admin/?mod=qa&action=delete&id={$qa[id].id}" class="ico ico-delete button" title="Удалить вопрос"></a>
			{elseif $qa[id].status == "approved"}
				<a href="/admin/?mod=qa&action=update&id={$qa[id].id}" class="ico ico-edit button" title="Изменить"></a>
				<a href="/admin/?mod=qa&action=suspend&id={$qa[id].id}" class="ico ico-no button" title="Отложить вопрос"></a>
				<a href="/admin/?mod=qa&action=delete&id={$qa[id].id}" class="ico ico-delete button" title="Удалить вопрос"></a>
			{elseif $qa[id].status == "deleted"}
				<a href="/admin/?mod=qa&action=update&id={$qa[id].id}" class="ico ico-ok button" title="Изменить"></a>
			{/if}
		</td>
	</tr>
{sectionelse}
  <tr>
    <td colspan="5" class="empty">вопросы отсутствуют</td>
  </tr>
{/section}
	<tr>
		<td colspan="5">
		{section name=pages loop=$qap}
			<a href="?mod=qa&p={$smarty.section.pages.iteration}" class="pageNo {if $qapc == $smarty.section.pages.iteration}current{/if}">{$smarty.section.pages.iteration}</a>
		{/section}
		</td>
	</tr>
</table>
