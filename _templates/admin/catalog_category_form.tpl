<form method="post" id="category_form" action="/admin/catalog/categoryUpdate/{$cid}">

	<label class="block mt20" for="category_title">Наименование</label>
	<input type="text" name="category_title" class="bigtext w100p" value="{$category.category_title|escape}" id="category_title">

	<label class="block mt20" for="category_title">Альтернативное наименование / Ключевые слова</label>
	<input type="text" name="category_alternative_title" class="bigtext w100p" value="{$category.category_alternative_title|escape}" id="category_title">


	<div class="mt20"><input type="checkbox" id="category_active" name="active" {if $category.active == 1}checked="checked" {/if}/> <label class="" for="category_active">Показывать раздел</label></div>

	<div class="mt20">
		<label class="block">Описание</label>
		<textarea class="tinymce" name="category_description" rows="5" style="width: 100%;">{$category.category_description}</textarea>
	</div>
	{if $category.is_leaf == 'true'}
	<div class="mt20">
		<h3>Форма вывода товаров</h3>
		<select name="category_view">
			<option value="list" {if $category.category_view == 'list'}selected="selected"{/if}>Списком</option>
			<option value="icons"  {if $category.category_view == 'icons'}selected="selected"{/if}>Иконками</option>
			<option value="plate"  {if $category.category_view == 'plate'}selected="selected"{/if}>Плиткой</option>
		</select>
	</div>

	<div class="mt20">
		<h3>Выделенные хатактеристики</h3>
		<table class="list mt10" id="cat_features_table">
		  <tr>
			<th>Свойство</th>
			<th>&nbsp;</th>
		  </tr>
		  <tr id="features_add" style="background-color:#efefef;">
			<td>
				<select name="feature_id" class="w100p" id="cat_select_feature_id">
					<option value="0"> --- Выберите свойство из списка --- </option>
					{strip}
					{section name="id" loop="$features_list"}
						<option value="{$features_list[id].id}">{$features_list[id].title} {if $features_list[id].unit != ''}({$features_list[id].unit}){/if}</option>
					{/section}
					{/strip}
				</select>
			</td>
				<td>
				<a href="#" onclick="addCategoryFeature();return false;" class="ico ico-greenplus button"></a>
			</td>
		  </tr>
		  <tr id="cat_features_empty">
			<td colspan="3" class="empty">Cвойства не определены</td>
		  </tr>
		</table>
	</div>
	<script type="text/javascript">$(function(){literal} { {/literal}loadCategoryFeatures({$category.category_id});{literal}}{/literal});</script>
	{/if}
	<div class="clr"></div>


	<div class="mt20" id="CategoryimageDiv">
		<div class="floatr">

			<div id="category_upload">
				<noscript>
					<p>Please enable JavaScript to use file uploader.</p>
				</noscript>
			</div>

		</div>
		{*<div class="floatr mr10 mt10"><input type="checkbox" name="item_show_image" id="item_show_image"><label for="item_show_image">Показывать</label></div>*}
		<div id="itemfileQueue" class="floatr mr10 Itemqueue" style="margin-top: -10px;"></div>
		<h3>Изображение</h3>

		<div id="CategoryimageContainer" class="form">

			{if $category.image_id !=''}
			<div class='item_image'>
				<div class='imageContainer' style='background-image: url(/images/catalog/50x50/{$category.image_file});'></div>
				<a href='#' class='button ico ico-delete' onclick="if (confirm('Подтвердите удаление изображения')) deleteCategoryImage({$category.category_id}); return false;"></a>
			</div>
			<div class='clr pb10'></div>
			{else}
				Изображение отсутствуют
			{/if}
		</div>

	</div>
	{*
	<div class="mt20">
		<label class="block">Ключевые слова</label>
		<input type="text" name="new_keyword" class="w250" value="" id="new_keyword"> <a href="#" class="ico ico-greenplus button" id="new_keyword_button">Добавить</a>
		<div class="mt10" id="keywords_list_editable"></div>
	</div>
	*}
</form>
