<div class="add_mode hide">
	<form method="post" id="category_form">
		<input type="hidden" name="action" value="category_add"/>
		<input type="hidden" name="mod" value="catalog"/>

		<label class="block mt20" for="newcategory_title">Наименование</label>
		<input type="text" name="category_title" class="bigtext w100p" value="" id="newcategory_title">

		<label class="block mt20" for="newcategory_alternative_title">Альтернативное наименование / Ключевые слова</label>
		<input type="text" name="newcategory_alternative_title" class="bigtext w100p" value="" id="newcategory_alternative_title">


		<div class="mt20"><input type="checkbox" id="newcategory_active" name="active" checked="checked" /> <label class="" for="newcategory_active">Показывать раздел</label></div>

		<div class="mt20">
			<label class="block">Описание</label>
			<textarea class="tinymce" name="category_description" rows="5" style="width: 100%;"></textarea>
		</div>

		<div class="mt20">
			<h3>Форма вывода товаров</h3>
			<select name="category_view">
				<option value="list" {if $category.category_view == 'list'}selected="selected"{/if}>Списком</option>
				<option value="icons"  {if $category.category_view == 'icons'}selected="selected"{/if}>Иконками</option>
				<option value="plate"  {if $category.category_view == 'plate'}selected="selected"{/if}>Плиткой</option>
			</select>
		</div>
		<div class="clr"></div>

</form>
</div>