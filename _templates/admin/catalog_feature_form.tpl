<div class="form mt10">
	<form method="POST" id="features_form">
		<input type="hidden" name="mod" value="catalog">
		<input type="hidden" name="action" value="category_feature_add">
		<input type="hidden" name="category_id" value="{$cid}">
		
		<h2 id="feature_form_title">Новое свойство</h2>
		
		<div class="mt20">
			<label class="mt20" for="feature_id">Свойство</label>
			<select name="feature_id" class="w100p" id="feature_id">
				{section name=id loop=$features_list}
				<option value="{$features_list[id].feature_id}">{$features_list[id].feature_title} {if $features_list[id].feature_unit !=''}({$features_list[id].feature_unit}){/if}</option>
				{/section}
			</select>
		</div>
		<div class="mt20">
			<input type="checkbox" name="feature_marked" id="feature_marked"/><label for="feature_marked">Выделенное свойство</label>
		</div>
		
	</form>
</div>
