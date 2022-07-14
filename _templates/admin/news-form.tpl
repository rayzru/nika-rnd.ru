<form method="POST" enctype="multipart/form-data">
	<input type="hidden" name="content_id" value="{$news.content_id}"/>
	<h1>{$formTitle}</h1>

	{if isset($errors)}
		<div class="alert alert-warning">
			<h4>Обнаружены ошибки</h4>
			<ul>
			{section name='i' loop="$errors"}<li>{$errors[i]}</li>{/section}
			</ul>
		</div>
	{/if}

	<div class="form-group">
		<label for="title">Заголовок</label>
		<input type="text" name="content_title" class="form-control" id="title" placeholder="Введите заголовок новости" value="{$news.content_title|escape}">
	</div>

	<div class="form-group">
		<label for="content">Новость</label>
		<textarea class="form-control" name="content_text" id="content" placeholder="" rows="10">{$news.content_text|escape}</textarea>
	</div>

	<div class="">
		<button type="submit" class="btn btn-success" onclick="$(this).addClass('disabled');">Сохранить</button>
		<a href="/admin/news" class="btn btn-default">Отмена</a>
	</div>
</form>

{literal}
	<script type="text/javascript">
		$('#content').wysihtml5({
			locale:"ru-RU",
			image: false,
			blockquote: false,
			html: true,
			parserRules: {tags:{a:{set_attributes:{target:"_self",rel:""}}}}
		});
	</script>
{/literal}