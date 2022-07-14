<div class="clr"></div>

<div class="ma w960" id="pathContainer">
	<h1>{$page_title}</h1>
	<ul id="path">
		<li><a href="/">Главная</a></li>
		<li><a href="/info/">информация покупателям</a></li>
		<li><a href="/info/qa">вопросы и ответы</a></li>
		<li>ответ на вопрос</li>
	</ul>
</div>

<div class="clr"></div>

<div  class="ma w960" >
	<div id="content_right_column">
		<div class="mt20 p20">
			<form action="/info/qa/" method="get">
				Найти в вопроса-ответах: <input type="text" value="{$qa_query}" name="query">
				<input type="submit" value="Найти">
			</form>
		</div>
		<div class="p20">
				Полезная информация:
				{include file="_right_column.tpl"}
		</div>
	</div>

	<div id="content_left_column" class="p20">
		<div class="floatr w200 f12px">
			<b>{$qa.name}</b><br/>
			<div class="gray">дата: <time datetime="{$qa.published_date}">{$qa.published_date|date_format:"%d.%m.%Y "}</time></div>
		</div>
		<div class="" style="width:440px;">
			     <strong>{$qa.title}</strong>
			     <p  style="color:#444;">{$qa.question}</p>
		</div>
		<hr size="1" style="color:#efefef;">
		<div class="floatr w200 f12px gray">Компания "Одиссей"</div>
		<div style="width:440px;color:#257fd9">{$qa.answer}</div>
	</div>
</div>

<div class="clr p20"></div>
