<form method="POST" id="item_form" action="" enctype="multipart/form-data">
	<input type="hidden" name="mod" value="catalog"/>
	<input type="hidden" name="action" value="item_add"/>
	<input type="hidden" name="category_id" value="{$cid}" id="category_id"/>
	<input type="hidden" name="category_id_bak" value="{$cid}" id="category_id_bak"/>
	<input type="hidden" name="leave_category" value="0" id="leaveId"/>
	<input type="hidden" name="item_id" value="0" id="item_id"/>
	<input type="hidden" name="image_id" value="0"/>
	<input type="submit" class="hide"/>
	<h2 id="item_form_title">Новый товар</h2>

	<table class="w100p">
		<tr>
			<td style="width:70%;">
				<label class="block" for="item_title">Наименование</label>
				<input type="text" class="w100p bigtext" value="" name="item_title" id="item_title"/>
			</td>
			<td class="pl20"  style="width:30%;">
				<label for="item_key">Артикул</label>
				<input type="text" class="w100p bigtext" value="" name="item_key" id="item_key"/>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<label class="block" for="item_alt_title">Альтернативное наименование</label>
				<input type="text" class="w100p bigtext" value="" name="item_alt_title" id="item_alt_title"/>
			</td>
		</tr>

	</table>


	<table class="w100p">
	<tr>
		<td  style="width:23%;" >
			<label class="block" for="item_price">Стоимость</label>
			<input type="text" class="w100p bigtext" value="" name="item_price" id="item_price"/>
		</td>
		<td class="pl20"  style="width:23%;" >
			<label class="block" for="item_unit">Единица измерения</label>
			<input type="text" class="w100p bigtext" value="" name="item_unit" id="item_unit"/>
		</td>
		<td class="pl20"  style="width:23%;" >
			<label class="block" for="item_active">Видимость</label>
			<select name="item_active" id="item_active">
				<option value="1">Показывать</option>
				<option value="0">Скрыть</option>
			</select>
		</td>
		<td class="pl20"  style="width:30%;" >
			<label class="block"  for="item_availability">Наличие</label>
			<select name="item_availability" id="item_availability">
				<option value="1">В наличии</option>
				<option value="0">Под заказ</option>
			</select>
		</td>
	</tr>
	</table>

	<div id="category_selector">
		Раздел:&nbsp;<b>{$category.category_title}</b>&nbsp;<a href="#" id="treeSelectorTrigger" class="button p2" onclick="category_selector();return false;">выбрать раздел</a>
		<div id="treeSelector">
			{include file="catalog_category_tree.tpl" tree=$categories}
		</div>
	</div>

	<div class="mt20">
		<input type="checkbox" id="item_new" name="item_new"> <label for="item_new">Данный товар является новинкой</label>
	</div>

	<div class="mt20">
		<label class="mt20" for="item_description_short">Краткое описание</label>
		<textarea class="tinymce" name="item_description_short" rows="5" style="width: 100%;" id="item_description_short"></textarea>
	</div>

	<div class="mt20">
		<label class="mt20" for="item_description">Описание</label>
		<textarea class="tinymce" name="item_description" rows="5" style="width: 100%;" id="item_description"></textarea>
	</div>

	{* <div class="mt20">
		<label class="block">Ключевые слова</label>
		<input type="text" name="new_item_keyword" class="w250" value="" id="new_item_keyword"> <a href="#" class="ico ico-greenplus button" id="new_item_eyword_button">Добавить</a>
		<div class="mt10" id="item_keywords_list_editable">

		</div>
	</div>
	*}


	<div class="advanced">

		<div class="mt20" id="itemimageDiv">
			<div class="floatr">
				<div id="item_upload"><noscript><p>Please enable JavaScript to use file uploader.</p></noscript></div>
			</div>
			<div class="hide floatr mr10 mt10"><input type="checkbox" name="item_show_image" id="item_show_image"><label for="item_show_image">Показывать</label></div>
			<div id="itemfileQueue" class="floatr mr10 Itemqueue" style="margin-top: -10px;"></div>
			<h3>Изображения</h3>

			<div id="itemimagesContainer" class="form">
				Изображения отсутствуют
			</div>
		</div>

		<div class="mt20">
			<h3>Характеристики товара</h3>
			<table class="list mt10" id="features_table">
			  <tr>
				<th>Наименование свойства</th>
				<th>Значение</th>
				<th>&nbsp;</th>
			  </tr>

			  <tr id="features_add" style="background-color:#efefef;">
				<td>
					<select name="feature_id" class="w100p" id="select_feature_id">
						<option value="0"> --- Выберите свойство из списка --- </option>
						{strip}
						{section name="id" loop="$features_list"}
							<option value="{$features_list[id].feature_id}">{$features_list[id].feature_title} {if $features_list[id].feature_unit != ''}({$features_list[id].feature_unit}){/if}</option>
						{/section}
						{/strip}
					</select>
				</td>
				<td>
					<input type="text" name="feature_value" value="" class="w100p" id="feature_value">
				</td>
				<td>
					<a href="#" onclick="addItemFeature();return false;" class="ico ico-approve button"></a>
				</td>
			  </tr>
			  <tr id="features_empty">
				<td colspan="3" class="empty">Cвойства не определены</td>
			  </tr>
			</table>

			<div class="form mb50">
				<select id="cloneItemFeatures" style="width:270px;"></select>
				<a href="#" class="ico ico-approve button" onclick="cloneItemFeatures(); return false;">Клонировать</a>
				<div class="floatr">
					<a href="#" class="ico ico-approve button" onclick="if (confirm('Сохранить измененные данные?')) return saveItemFeatures(); return false;">Сохранить изменения</a>
					<a href="#" class="ico ico-delete button" onclick="if (confirm('действительно удалить все введенные характеристики?')) return deleteItemFeatures();">Удалить</a>
				</div>
			</div>
		</div>
	</div>
</form>
