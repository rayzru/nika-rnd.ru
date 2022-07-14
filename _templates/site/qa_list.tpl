<div class="clr"></div>

<div class="ma w960" id="pathContainer">
	<h1>{$page_title}</h1>
	<ul id="path">
		<li><a href="/">Главная</a></li>
		<li><a href="/info/">информация покупателям</a></li>
		<li><a href="/info/qa">вопросы и ответы</a></li>
		<li>страница {$qa_page}</li>
	</ul>
</div>

<div class="clr"></div>

<div  class="ma w960" >
	<div id="content_right_column" >
		<div  class="p20">
			<div>
				Категории вопросов:
				<ul>
					{if $qa_cid == 0}
						<li><b>Все категории</b></li>
					{else}
						<li><a href="/info/qa/?query={$qa_query}&page={$qa_page}">Все категории</a></li>
					{/if}
					{section name="id" loop="$qc"}
						{if $qa_cid == $qc[id].id}
							<li><b>{$qc[id].category_title}</b></li>
						{else}
							<li><a href="/info/qa/?query={$qa_query}&page={$qa_page}&cid={$qc[id].id}">{$qc[id].category_title}</a></li>
						{/if}
					{/section}
				</ul>
				Полезная информация:
			{include file="_right_column.tpl"}

			</div>
		</div>
	</div>

	<div id="content_left_column" class="p20">
		{if $asked == 1}
			{literal}<script type="text/javascript">$(function(){showNotify('Ваш вопрос отправлен на модерацию');});</script>{/literal}
		{/if}

		<div class="mt20 mb20" style="line-height: 40px;">
			<a href="#" id="qaFormTrigger" class="floatr w200 "><img src="/images/ask.png" alt="Задать вопрос" width="159" height="39" border="0"></a>
			<form action="" class="mb20">
				<input type="text" value="{$qa_query}" name="query" class="w300">
				<input type="submit" value="Найти">
			</form>
		</div>
		<div id="qaForm" class="mb20 mt10">

            Если вы заинтересованы в ответе, оставляйте вашу контактную информацию (электронный почтовый адрес или телефон), что бы наши специалисты смогли связаться с вами и ответить в полной мере на ваш вопрос. <br/>

			<form action="/info/qa/" method="post">
				<input type="hidden" name="item_id" value="{$item.item_id}">
				<table>
					<tr>
						<td width="100"><label>Ваше имя:</label></td>
						<td><input type="text" name="qa_name" required="required" class="w300" value="{$account->name}"></td>
					</tr>
					<tr>
						<td width="100"><label>Email</label></td>
						<td><input type="text" name="qa_email" required="required" class="w300" value="{$account->email}"></td>
					</tr>
					<tr>
						<td width="100"><label>Город</label></td>
						<td><input type="text" name="qa_address" required="required" class="w300"></td>
					</tr>
					<tr>
						<td width="100"><label>Категория</label></td>
						<td>
							<select name="category_id">
								<option value="1">Каталог оборудования</option>
							</select>
						</td>
					</tr>
					<tr>
						<td width="100"><label>Заголовок</label></td>
						<td><input type="text" name="qa_title" required="required" class="w300"></td>
					</tr>
					<tr>
						<td width="100"><label>Ваш вопрос</label></td>
						<td><textarea name="qa_text" required="required" class="w300" cols="80" rows="5"></textarea></td>
					</tr>
					<tr>
						<td width="100"></td>
						<td><input type="submit" value="Задать вопрос"></td>
					</tr>
					<tr>
						<td width="100"></td>
						<td class="gray">Все поля формы являются обязательными. Постарайтесь четко и ясно сформулировать свои вопросы.</td>
					</tr>
				</table>
			</form>
		</div>

	{section name="id" loop="$qa"}
		<div class="floatr w200 f12px">
			<b>{$qa[id].name}</b><br/>
			<div class="gray"><time datetime="{$qa[id].published_date}">{$qa[id].published_date|date_format}</time></div>
			{if $qa[id].item_id != 0}
			<div class="clr"></div>
			<div class="mt10 gray f10px">
				Вопрос был задан к товару<br/>
				<a href="/catalog/?id={$qa[id].item_id}">{$qa[id].item_title}</a>
			</div>
			{/if}

		</div>
		<div class="" style="width:440px;">
			     <strong><a href="/info/qa/?view={$qa[id].id}">{$qa[id].title}</a></strong>
			     <p>{$qa[id].question}</p>
		</div>
		<hr size="1" style="color:#efefef;">
	{sectionelse}
		<div class="gray center">вопросы не найдены</div>
	{/section}


	    {if $qa_pages > 1}
		<div class="center">

			<span class="gray">Страницы</span>
		{section name=i loop=$qa_pages}
		    {if $smarty.section.i.iteration == $qa_page}
			{$smarty.section.i.iteration}
			{else}
			<a href="/info/qa/?query={$qa_query}&page={$smarty.section.i.iteration}&cid={$qa_cid}">{$smarty.section.i.iteration}</a>
			{/if}
		{/section}
		</div>
		{/if}
	</div>
</div>

<div class="clr p20"></div>

{literal}
<script type="text/javascript">
$(function(){
	$('#qaFormTrigger').click(function(e){
		$('#qaFormTrigger, #qaForm').toggle();
		e.stopPropagation();
		return false;
	});
});
</script>
{/literal}
