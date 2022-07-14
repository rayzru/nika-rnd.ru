<h3>Новый подраздел</h3>
<form role="form" method="post">

	<div class="form-group">
		<label>Наименование</label>
		<input class="form-control" type="text" name="category_title" class="" value="{$category.category_title|escape}">
	</div>

	<div class="form-group">
		<label for="category_alternative_title">Альтернативное наименование / Ключевые слова</label>
		<input class="form-control" type="text" name="category_alternative_title" value="{$category.category_alternative_title|escape}" id="category_title">
	</div>


	<div class="checkbox">

		<label>
			<input type="checkbox" name="active" {if $category.active == 1}checked="checked"{/if} />
			Показывать раздел
		</label>
	</div>

	<div class="form-group">
		<label>Описание</label>
		<textarea class="form-control tinymce" name="category_description" rows="5" style="width: 100%;">{$category.category_description}</textarea>
	</div>

	<div class="form-group">
		<button type="button" class="btn btn-default" onclick="location.href='/admin/catalog/viewCategory/{$category.category_id}'">Отмена</button>
		<button type="submit" class="btn btn-success"><i class="glyphicon glyphicon-ok"></i> Сохранить</button>
	</div>
</form>
