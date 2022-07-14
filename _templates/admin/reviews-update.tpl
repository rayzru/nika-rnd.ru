<ol class="breadcrumb">
	<li><a href="/admin">Главная</a></li>
	<li><a href="/admin/reviews/">Отзывы пользователей</a></li>
	<li class="active">Отзыв {$review.id}</li>
</ol>

<h1>Отзыв</h1>

<form method="post" role="form">
	<input type="hidden" value="{$review.id}" name="id">

	<div class="row">
		<div class="col-md-8">
			<div class="question">
				<h4 style="line-height: 1.5em;">{$review.review}</h4>
				<div class="form-group question-group" style="display: none;">
					<textarea rows="10" class="wysiwyg form-control" name="review">{$review.review}</textarea>
				</div>

				<div class="form-group">
					<button type="button" class="btn btn-default btnedit" onclick="$('.question h4, .question .question-group, .question .btnedit').toggle();$('.wysiwyg').wysihtml5({*ldelim}locale:"ru-RU"{rdelim*});return false;">Редактировать</button>

					<div class="btn-group" data-toggle="buttons">
						<label class="btn btn-default {if $review.approved == '1'}active{/if}">
							<input type="radio" name="approved" value="1" {if $review.approved == '1'}checked="checked"{/if}> Подтвержден
						</label>
						<label class="btn btn-default {if $review.approved == '0'}active{/if}">
							<input type="radio" name="approved" value="0" {if $review.approved == '0'}checked="checked"{/if}> Не подтвержден
						</label>
					</div>

					{if isset($review.rating)}
						<div class="form-control-static pull-right">
							<span class="avgrating userRating"></span>
						</div>
					{literal}
						<script type="text/javascript">
							$(function(){
								$('.avgrating').raty({
									starType: 'i',
									score: {/literal}{$review.rating}{literal},
									hints: ['Очень плохо!', 'Плохо', 'Нормально', 'Хорошо', 'Отлично!'],
									halfShow: true,
									readOnly: true
								});
							});
						</script>
					{/literal}
					{/if}
				</div>
			</div>

			<div class="form-group">
				<a href="/admin/reviews/" class="btn btn-default ">Вернуться к списку</a>
				<a href="/admin/reviews/delete/{$review.id}" class="btn btn-danger" onclick="return confirm('Вы действительно хотите удалить текущий обзор?');">Удалить</a>
				<button type="submit" class="btn btn-success ">Сохранить</button>
				&nbsp;<div class="checkbox-inline">
					<label><input type="checkbox" value="1" name="resolve" checked="checked"> Подтвердить обзор</label>
				</div>
			</div>
		</div>

		<div class="col-md-4">
			<div class="well">
				<h4><i class="fa fa-user"></i> {$review.name}</h4>
				<p>{$review.rate_date|date_format:"%d %m %Y"}</p>
				<p><i class="fa fa-link"></i> <a href="/catalog/viewItem/{$review.item_id}" target="_blank" title="Открыть товар в новом окне">{$review.item_title}</a></p>
			</div>
		</div>
	</div>
</form>
