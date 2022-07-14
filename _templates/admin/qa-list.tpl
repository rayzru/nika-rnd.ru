<ol class="breadcrumb">
	<li><a href="/admin">Главная</a></li>
	<li class="active">Вопросы-ответы</li>
</ol>

<h1>Вопросы-ответы, консультации</h1>

<div class="well well-sm">
	<div class="btn-group pull-right" data-toggle="buttons" id="">
		<a href="#" class="btn btn-default disabled btn-multiple" data-loading-text="Удаление...">Удалить выбранные</a>
	</div>
	<div class="btn-group" data-toggle="buttons" id="statuses">
		<label class="btn btn-primary">
			<input type="checkbox"  name="status" value="queued"> Ожидает ответа
		</label>
		<label class="btn btn-primary">
			<input type="checkbox"  name="status" value="closed"> Закрыт
		</label>
	</div>

</div>

<table class="table table-qa">
<thead>
<tr>
	<th></th>
	<th></th>
	<th>Дата</th>
	<th>Статус</th>
	<th>Вопрос</th>
	<th></th>
</tr>
</thead>
<tbody>
{section name=id loop=$qa}
	<tr class="" rel="{$qa[id].id}">
		<td style="width: 40px;"><i class="fa fa-square-o"></i></td>
		<td>{if $qa[id].active == 1}<i class="fa fa-eye"></i>{/if}</td>
		<td class="text-muted" width="150" data-order="{$qa[id].published_date}">{$qa[id].published_date|date_format:"%d %m %Y"}</td>
		<td width="100">
			{assign var="status" value="`$qa[id].status`"}
			<span class="label label-{if $status == "queued"}success{elseif $status == "closed"}default{/if}">
				{if $status == "queued"}ожидает ответа{elseif $status == "closed"}закрыт{/if}
			</span>
		</td>
		<td>{$qa[id].question}</td>
		<td class="text-right" width="150">
			<a href="/admin/qa/update/{$qa[id].id}" class="btn btn-default btn-xs" title="Изменить"><i class="fa fa-edit"></i> Ответить</a>
			<a href="/admin/qa/delete/{$qa[id].id}" class="btn btn-default btn-xs" title="Удалить вопрос" onclick="return confirm('Подтвердите удаление вопроса');"><i class="fa fa-times"></i></a>
		</td>
	</tr>
{sectionelse}
	 <tr><td colspan="5" class="text-muted">Вопросы отсутствуют</td></tr>
{/section}
</tbody>
</table>

<div class="" style="padding-bottom: 30px;">
	<ul class="pagination">
		{assign var="pages" value=`$qaItems/$qaPageSize`}
		{section name=i start=1 loop=$pages step=1}
			<li {if $qaPage == $smarty.section.i.index}class="active" {/if}><a href="/admin/qa/list/{$smarty.section.i.index}/?s={$statuses}">{$smarty.section.i.index}</a></li>
		{/section}
	</ul>
</div>

{literal}
<script type="text/javascript">
	$(function(){

		function selectedArray() {
			return $('.table-qa tr.info').map(function() {
				return $(this).attr('rel');
			}).get();
		}

		var statuses = getParameterByName('s').split(',');
		if (statuses != '') $(statuses).each(function(k,v){
			$('input[value=' + v + ']').attr('checked', 'checked').parent().addClass('active');
		});

		if (statuses == '') $('input[value="queued"]').attr('checked', 'checked').parent().addClass('active');

		$('#statuses :checkbox').change(function(){
			var s = $( "#statuses :checked" ).map(function() {return this.value; }).get().join();
			document.location.href = location.protocol + '//' + location.host + location.pathname + "?s=" + s;
		});


		$('.table-qa tbody tr').on('click', function(e) {
			$(this).toggleClass('info');

			if ($("td .fa-square-o", this).length) {
				$("td .fa-square-o", this).removeClass("fa-square-o").addClass('fa-check-square-o');
			} else {
				$("td .fa-check-square-o", this).removeClass("fa-check-square-o").addClass('fa-square-o');
			}

			var l = selectedArray();
			if (l.length > 0) {
				$('.btn-multiple').removeClass('disabled');
			} else {
				$('.btn-multiple').addClass('disabled');
			}

		});

		$('.btn-multiple').on('click', function(e){
			e.preventDefault();
			if (confirm ('Подтвердите удаление выбранных вопросов')) {
				var l = selectedArray();
				if (l.length > 0) {
					$('.btn-multiple').button('loading');
					$.post('/admin/qa/delete', {ids : l})
							.done(function() {
								location.reload();
							});
				}
			}
		});

	});
</script>
{/literal}