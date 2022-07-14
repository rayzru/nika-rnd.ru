<ol class="breadcrumb">
	<li><a href="/admin">Главная</a></li>
	<li class="active">Отзывы пользователей</li>
</ol>

<h1>Отзывы, обзоры</h1>

<div class="well well-sm">
	<div class="checkbox-inline">
		<label style="margin-bottom: 0;">
			<input type="checkbox" name="hideChecked" value="1" {if $filter}checked="checked"{/if}> Скрыть проверенные
		</label>
	</div>
</div>

<table class="table table-hover table-reviews">
	<thead>
	<tr>
		<th></th>
		<th>Дата</th>
		<th>Отзыв</th>
		<th></th>
	</tr>
	</thead>
	<tbody>
	{section name="i" loop="$reviews"}
		<tr class="" rel="{$reviews[i].id}">
			<td style="width: 40px;"><i class="fa fa-square-o"></i></td>
			<td><span class="label label-{if $reviews[i].approved == 1}success{else}warning{/if}">{if $reviews[i].approved == 1}Проверн{else}Не проверен{/if}</span></td>
			<td>{$reviews[i].rate_date|date_format:"%d %m %Y"}</td>
			<td>
				<div class="userRating">
					{section name=j loop=6 start=1 max=6}
						{assign var="rating" value=`$reviews[i].rating`}
						{assign var="index" value=`$smarty.section.j.index`}
						<i class="fa fa-star{if $index > $rating }-o{/if}"></i>
					{/section}
				</div>
				{$reviews[i].review}
			</td>
			<td class="text-right">
				<a href="/admin/reviews/update/{$reviews[i].id}" class="btn btn-xs btn-default" title="Редактировать"><i class="fa fa-edit"></i></a>
				<a href="/admin/reviews/delete/{$reviews[i].id}" class="btn btn-xs btn-danger" title="Удалить" onclick="return confirm('Действительно удалить?');"><i class="fa fa-times"></i></a>
			</td>
		</tr>
	{/section}
	</tbody>
</table>

<div class="">
	 <a href="#" class="btn btn-default disabled btn-multiple" data-loading-text="Удаление...">Удалить выбранные</a>
</div>
{literal}
<script type="application/ecmascript">
	$(function(){
		$('[name=hideChecked]').change(function(){
			var param = ($(this).is(':checked')) ? "?filter=1" : "";
			loading();
			document.location.href="/admin/reviews/list" + param;
		});

		function selectedArray() {
			return $('.table-reviews tr.info').map(function() {
				return $(this).attr('rel');
			}).get();
		}

		$('.table-reviews tbody tr').on('click', function(e){
			$(this).toggleClass('info');
			if ($("td .fa-square-o", this).length) {
				$("td .fa-square-o", this).removeClass("fa-square-o").addClass('fa-check-square-o');
			} else {
				$("td .fa-check-square-o", this).removeClass("fa-check-square-o").addClass('fa-square-o');
			}

			var l = selectedArray();
			if (l.length > 0) $('.btn-multiple').removeClass('disabled'); else $('.btn-multiple').addClass('disabled');

		});

		$('.btn-multiple').on('click', function(e){
			e.preventDefault();
			if (confirm ('Подтвердите удаление выбранных отзывов')) {
				var l = selectedArray();
				if (l.length > 0) {
					$('.btn-multiple').button('loading');
					$.post('/admin/reviews/delete', {ids : l})
							.done(function() {
								location.reload();
							});
				}
			}
		});


	});
</script>
{/literal}
