<h3>Редактирование раздела</h3>
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


	<div class="panel panel-default">
		<div class="panel-heading">
			Ключевые слова
		</div>
		<div class="panel-body">
			<input type="text" name="category_keywords" id="category_keywords" value="" class="form-control">
			<input type="hidden" name="category_keywords_values" id="category_keywords_values" value="">
			{literal}
			<script type="application/javascript">
				$(function(){
					$('#category_keywords')
							.val([{/literal}{section name=k loop=$category_keywords}{if !$smarty.section.k.first},{/if}{$category_keywords[k].id}{/section}{literal}])
							.select2({
								placeholder: "Клчевые слова",
								minimumInputLength: 2,
								multiple: true,
								ajax: { // instead of writing the function to execute the request we use Select2's convenient helper
									url: "/admin/catalog/getKeywords/",
									dataType: 'json',
									data: function (term, page) {
										return {
											q: term, // search term
											page_limit: 10,
											page: page
										};
									},

									results: function (data, page) {
										return {results: data.keywords};
									}
								},
								createSearchChoice: function(term, data) {

									if ($(data).filter( function() { return this.text.localeCompare(term)===0; }).length===0) {
										return {id:term, text:term};
									}
								},
								initSelection: function(element, callback) {
									$.ajax("/admin/catalog/getCategoryKeywords/{/literal}{$category.category_id}{literal}/", {
										dataType: "json"
									}).done(function(data) { callback(data.keywords); });
								},
								escapeMarkup: function (m) { return m; }
							}).on('change', function() {
								var selected = $('#category_keywords').select2('data');
								var str = "";
								$.each(selected, function(k, v){
									str = str +  ((str.length) ? ',' : '') + this.text
								});
								$('#category_keywords_values').val(str);
							});
				});
			</script>
			{/literal}
		</div>
	</div>



	{if $category.category_id != ''}
	<div class="panel panel-default">
		<div class="panel-heading">
			Изображение
		</div>
		<div class="panel-body">
			<div class="row">
				<div class="col-md-4 categoryImage">
					{if $category.image_id !=''}
						<div class='thumbnail' style="position: relative;">
							<div class='image' style='background-image: url(/images/catalog/150x150/{$category.image_file});'></div>
							<a href='#' class='btn btn-default btn-sm btn-danger' onclick="if (confirm('Подтвердите удаление изображения')) deleteCategoryImage({$category.category_id}); return false;"><i class="fa fa-times"></i></a>
						</div>
					{else}
						Изображение отсутствуют
					{/if}
				</div>
				<div class="col-md-4">
					<div id="category_upload">
						<noscript><p>Please enable JavaScript to use file uploader.</p></noscript>
					</div>
					<div id="itemfileQueue" class="Itemqueue" style="margin-top: -10px;"></div>
					<div class="checkbox" style="margin-top: 20px;">
						<label>
							<input type="checkbox" name="show_image" {if $category.show_image == 1}checked="checked"{/if} />
							Показывать изображение
						</label>
					</div>
				</div>
				{literal}
					<script type="application/ecmascript">
						uploaderCat = new qq.FileUploader({
							element: document.getElementById('category_upload'),
							action: '/admin/uploadCat.php',
							sizeLimit: 0, // max size
							minSizeLimit: 0, // min size
							debug: false,
							params: {cid: {/literal}{$category.category_id}{literal}},
							onComplete: function(id, fileName, responseJSON){
								$.ajax({
									url: '/admin/catalog/getCategoryImage/{/literal}{$category.category_id}{literal}',
									dataType: 'text',
									success : function(data) {
										if (data != '') {
											$('.categoryImage')
													.empty()
													.append("<div class='thumbnail' style='position: relative;'>" +
																"<div class='image' style='background-image: url(/images/catalog/150x150/" + data + ");'></div>" +
																"<a href='#' class='btn btn-default btn-sm btn-danger' onclick='if (confirm(\"Подтвердите удаление изображения\")) deleteCategoryImage({/literal}{$category.category_id}{literal}); return false;'><i class='fa fa-times'></i></a>" +
															"</div>");
										}
									}
								});
								$('#category_upload .qq-upload-list').empty();
							}
						});
					</script>
				{/literal}
			</div>
		</div>
	</div>
	{/if}

	{if $category.is_leaf == 'true'}
		<div class="form-group">
			<label class="btn-block">Формат вывода товаров</label>
			<div class="btn-group" data-toggle="buttons">
				<label class="btn btn-default {if $category.category_view == 'list'}active{/if}">
					<input type="radio" name="category_view" {if $category.category_view == 'list'}checked="checked"{/if} value="list"> <i class="fa fa-th-list"></i>
				</label>
				<label class="btn btn-default {if $category.category_view == 'icons'}active{/if}">
					<input type="radio" name="category_view" {if $category.category_view == 'icons'}checked="checked"{/if} value="icons"> <i class="fa fa-th"></i>
				</label>
				<!--label class="btn btn-default  {if $category.category_view == 'plate'}active{/if}">
					<input type="radio" name="category_view" {if $category.category_view == 'plate'}checked="checked"{/if} value="plate"> <i class="glyphicon glyphicon-th-large"></i>
				</label-->
			</div>
		</div>


		<div class="panel panel-default">
			<div class="panel-heading">Выделенные хатактеристики</div>
			<div class="panel-body">
				<select id="categoryFeatures" name="category_features" multiple="multiple" style="width: 100%;">
					{strip}{section name="id" loop="$features"}<option value="{$features[id].id}">{$features[id].title}{if $features[id].unit != ''} ({$features[id].unit}){/if}</option>{/section}{/strip}
				</select>
			</div>
		</div>
	{/if}

	<div class="form-group">
		<a href="/admin/catalog/viewCategory/{$category.category_id}" class="btn btn-default">Отмена</a>
		<button type="submit" class="btn btn-success"><i class="fa fa-check"></i> Сохранить</button>
	</div>
</form>
<script type="application/javascript">
	{literal}
	$(function(){
		function format(item) {
			return item.title;
		}

		$('#categoryFeatures')
				.val({/literal}[{section name=i loop="$featuresAssigned"}{$featuresAssigned[i].feature_id}{if !$smarty.section.i.last},{/if}{/section}]{literal})
				.select2()
				.on('change', function(e){
					var val = (typeof e.added !== 'undefined') ? e.added.id : (typeof e.removed !== 'undefined') ? e.removed.id : 0;
					var action = (e.added) ? 'add' : (e.removed) ? 'delete' : false;
					if (action) $.ajax({
						type: "POST",
						url: '/admin/catalog/' + action + 'CategoryFeature/{/literal}{$category.category_id}{literal}',
						dataType: 'json',
						data: {id: val},
						success: function(data) {}
					});
				});

		$('.tinymce').wysihtml5({
			locale:"ru-RU",
			image: false,
			blockquote: false,
			html: true,
			parserRules: {tags:{a:{set_attributes:{target:"_self",rel:""}}}}

		});
	});
	{/literal}
</script>
