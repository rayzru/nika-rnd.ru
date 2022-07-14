<form method="POST" id="item_form" action="" enctype="multipart/form-data">
	<div class="pull-right">
		<a href="/catalog/viewItem/{$item.item_id}" target="_blank"><i class="fa fa-link"></i> посмотреть страницу товара</a>
	</div>
	<h3>Редактирование товара</h3>

	<div class="form-group">
		<div class="row">
			<div class="col-md-9">
				<label class="" for="item_title">Наименование</label>
				<input type="text" class="form-control" value="{$item.item_title|escape}" name="item_title" id="item_title"/>
			</div>
			<div  class="col-md-3">
				<label for="item_key">Артикул</label>
				<input type="text" class="form-control" value="{$item.item_key}" name="item_key" id="item_key"/>
			</div>
		</div>
	</div>
	<div class="form-group">
		<label class="block" for="item_alt_title">Альтернативное наименование</label>
		<input type="text" class="form-control" value="{$item.item_title_alternative|escape}" name="item_alt_title" id="item_alt_title"/>
	</div>

	<div class="form-group">
		<div class="row">
			<div class="col-md-6">
				<label for="item_price">Стоимость</label>
				<div class="input-group">
					<input type="number" class="form-control" value="{$item.price}" name="item_price" id="item_price" />
					<span class="input-group-addon">руб.</span>
				</div>
			</div>
			<div class="col-md-6">
				<label for="item_price">Розничная цена</label>
				<div class="checkbox">
					<label><input type="checkbox" name="price_warn" {if $item.price_warn == 1}checked="checked"{/if}/> Предупреждать</label>
				</div>
			</div>
		</div>
	</div>

	<div class="form-group">
		<div class="row">
			<div class="col-md-2">
				<label class="block" for="item_unit">Ед. изм.</label>
				<input type="text" class="form-control" value="{$item.item_unit}" name="item_unit" id="item_unit"/>
			</div>
			<div class="col-md-3">
				<label class="block" for="item_active">Видимость</label>
				<select name="item_active" id="item_active" class="form-control">
					<option value="1" {if ($item.active == 1)}selected="selected"{/if}>Показывать</option>
					<option value="0" {if ($item.active == 0)}selected="selected"{/if}>Скрыть</option>
				</select>
			</div>
			<div class="col-md-3">
				<label class="block"  for="item_availability">Наличие</label>
				<select name="item_availability" id="item_availability" class="form-control">
					<option value="1" {if ($item.availability == 1)}selected="selected"{/if}>В наличии</option>
					<option value="0" {if ($item.availability == 0)}selected="selected"{/if}>Под заказ</option>
					<option value="2" {if ($item.availability == 2)}selected="selected"{/if}>Временно отсутствует</option>
				</select>
			</div>
			<div class="col-md-4">
				<label class="block" for="arrives_in">Срок доставки при заказе</label>
				<select name="arrives_in" id="arrives_in" class="form-control">
					<option value="0" {if ($item.arrives_in == 0)}selected="selected"{/if}>Доступно</option>
					<option value="2" {if ($item.arrives_in == 2)}selected="selected"{/if}>1-2 дня</option>
					<option value="5" {if ($item.arrives_in == 5)}selected="selected"{/if}>5 дней</option>
					<option value="7" {if ($item.arrives_in == 7)}selected="selected"{/if}>Неделя</option>
					<option value="14" {if ($item.arrives_in == 14)}selected="selected"{/if}>2 недели</option>
					<option value="30" {if ($item.arrives_in == 30)}selected="selected"{/if}>Месяц</option>
					<option value="60" {if ($item.arrives_in == 60)}selected="selected"{/if}>2 месяца</option>
					<option value="999" {if ($item.arrives_in == 999)}selected="selected"{/if}>Неизвестно</option>
				</select>
			</div>
		</div>
	</div>

	<div class="form-group">
		<label>Раздел</label>
		<input class="selectCategory" name="category_id" value="{$category.category_id}" style="width: 100%;">
		<!--input type="text" class="selectCategory form-control" value="{$category.category_title|escape}"-->
		{literal}
		<script type="application/javascript">
			$(function(){
				$('.selectCategory').select2({
					placeholder: "Выберите раздел",
					minimumInputLength: 2,
					ajax: { // instead of writing the function to execute the request we use Select2's convenient helper
						url: "/admin/catalog/getLeafCategories/",
						dataType: 'json',
						data: function (term, page) {
							return {
								q: term, // search term
								page_limit: 10,
								page: page
							};
						},

						results: function (data, page) {
							return {results: data.categories};
						}
					},
					initSelection: function(element, callback) {
						$.ajax("/admin/catalog/getLeafCategories/{/literal}{$category.category_id}{literal}/", {
							dataType: "json"
						}).done(function(data) { callback(data); });
					},
					escapeMarkup: function (m) { return m; }
				}).on("change", function(e) {
					//console.log(e);
					$('.selectCategory').attr('value', e.val);
				})
			});
		</script>
		{/literal}
	</div>

	<div class="form-group">
		<div class="row">
			<div class="col-md-6">
				<div class="checkbox">
					<label><input type="checkbox" name="item_new" {if isset($item.item_new) && $item.item_new!= 0}checked="checked"{/if} /> Данный товар является новинкой</label>
				</div>
			</div>
			<div class="col-md-6">
				<div class="checkbox">
					<label><input type="checkbox" name="commission" {if isset($item.commission) && $item.commission!= 0}checked="checked"{/if} /> Данный товар является коммиссионным</label>
				</div>
			</div>
		</div>
	</div>
	<div class="form-group">
		<h4>Описание</h4>
		<textarea class="form-control" name="item_description" rows="10" id="item_description">{$item.item_description|stripcslashes}</textarea>
	</div>
	<div class="panel panel-default">
		<div class="panel-heading">
			Ключевые слова
		</div>
		<div class="panel-body">
			<input type="text" name="item_keywords" id="item_keywords" value="" class="form-control">
			<input type="hidden" name="item_keywords_values" id="item_keywords_values" value="">
			{literal}
			<script type="application/javascript">
				$(function(){
					$('#item_keywords')
							.val([{/literal}{section name=k loop=$item_keywords}{if !$smarty.section.k.first},{/if}{$item_keywords[k].id}{/section}{literal}])
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
									$.ajax("/admin/catalog/getItemKeywords/{/literal}{$item.item_id}{literal}/", {
										dataType: "json"
									}).done(function(data) { callback(data.keywords); });
								},
								escapeMarkup: function (m) { return m; }
							}).on('change', function() {
								var selected = $('#item_keywords').select2('data');
								var str = "";
								$.each(selected, function(k, v){
									str = str +  ((str.length) ? ',' : '') + this.text
								});
								$('#item_keywords_values').val(str);
							});
				});
			</script>
			{/literal}
		</div>
	</div>

	<div class="panel panel-default">
		<div class="panel-heading">
			Изображения
		</div>
		<div class="panel-body">
			<div class="col-md-4">
				<div class="form-group">
					<div id="item_upload"><noscript><p>Please enable JavaScript to use file uploader.</p></noscript></div>
				</div>
				<div class="form-group">
					<div class="checkbox-inline">
						<label>
							<input type="checkbox" name="item_show_image" {if $item.show_image == 'true'}checked="checked"{/if} /> Показывать изображения
						</label>
					</div>
				</div>

				<div id="itemfileQueue"></div>

			</div>
			<div class="col-md-8" id="itemImagesContainer">
				{assign var="images" value=$item.images }
				{include file="catalog-itemImages.tpl"}
			</div>
		</div>
	</div>


	<div class="panel panel-default">
		<div class="panel-heading">
			Характеристики
		</div>
		<div class="panel-body">
			<table class="table" id="features_table">
				<thead>
					<tr>
						<th>Наименование свойства</th>
						<th>Значение</th>
						<th>&nbsp;</th>
					</tr>
				</thead>
				<tbody>
				{section name=id loop=`$item.features`}
					<tr rel="{$item.features[id].feature_id}">
						<td width="40%">{$item.features[id].title}</td>
						<td>
							{if $item.features[id].unit != ''}
							<div class="input-group">
								<input name="feature[{$item.features[id].feature_id}]" value="{$item.features[id].feature_value|escape}" type="text" class="form-control">
								<span class="input-group-addon">{$item.features[id].unit|trim}</span>
							</div>
							{else}
								<input name="feature[{$item.features[id].feature_id}]" value="{$item.features[id].feature_value|escape}" type="text" class="form-control">
							{/if}
							</td>
						<td><button class="btn btn-default btn-small delete-feature" type="button" value="{$item.features[id].feature_id}" title="Удалить характеристику товароа"><i class="fa fa-times"></i></button></td>
					</tr>
				{/section}
				</tbody>
				<tfoot>
					<tr>
						<td colspan="3">
							<div class="row">
								<div class="col-md-7">
									<select class="w100p" id="select_feature_id">
										{strip}
											{section name="id" loop="$features_list"}
												<option value="{$features_list[id].id}" rel="{$features_list[id].unit|trim}">{$features_list[id].title} {if $features_list[id].unit != ''}({$features_list[id].unit|trim}){/if}</option>
											{/section}
										{/strip}
									</select>
								</div>
								<div class="col-md-5">


									<div class="btn-group">
										<button class="btn btn-success" id="btn-add-feature" type="button">Добавить</button>

										<div class="btn-group dropup">
											<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
												Клонировать из...
												<span class="caret"></span>
											</button>
											<ul class="dropdown-menu" role="menu" id="cloneTarget">
												{section name="id" loop="$cloneItems"}
												{if $cloneItems[id].item_id != $item.item_id}<li><a href="#" rel="{$cloneItems[id].item_id}" >{$cloneItems[id].item_title}</a></li>{/if}
												{/section}
											</ul>
										</div>
									</div>

								</div>
							</div>
						</td>
					</tr>
				</tfoot>
			</table>
		</div>
	</div>

	<div class="form-group">
		<a href="/admin/catalog/viewItems/{$category.category_id}" class="btn btn-default">Отмена</a>
		<button type="submit" name="continue_editing" value="1" class="btn btn-success" title="Созранить настройки товара и остаться в форме редактирования">Применить</button>
		<button type="submit" name="return" value="1" class="btn btn-success">Сохранить</button>

		<a href="/catalog/viewItem/{$item.item_id}" class="btn btn-default pull-right" target="_blank">Открыть страницу с товаром</a>
	</div>

</form>

{literal}
<script type="application/ecmascript">
	function deleteImage(id) {
		$('#itemImagesContainer').block({message: "Загрузка..."});
		$.post('/admin/catalog/deleteItemImage/'+ id, function(data){
			$('#itemImagesContainer').html(data);
		})
	}

	function updateImages() {
		$('#itemImagesContainer').block({message: "Загрузка..."});
		$.post('/admin/catalog/getItemImages/{/literal}{$item.item_id}{literal}',function(data){
			$('#itemImagesContainer').html(data);
		})
	}

	function setDefaultImage(id) {
		$('#itemImagesContainer').block({message: "Загрузка..."});
		$.post('/admin/catalog/setDefaultImage/' + id,function(data){
			$('#itemImagesContainer').html(data);
		})
	}

	$(function(){
		$('#item_description').wysihtml5({
			locale: "ru-RU",
			image: false,
			size: 'sm',
			blockquote: false,
			html: true,
			fa: true,
			parser: function(html) {return html;},
			parserRules: {tags:{a:{set_attributes:{target:"_self",rel:""}}}}
		});

		uploader = new qq.FileUploader({
			element: document.getElementById('item_upload'),
			action: '/admin/upload.php',
			sizeLimit: 0, // max size
			minSizeLimit: 0, // min size
			debug: false,
			params: {
				item_id: {/literal}{$item.item_id}{literal}
			},
			onComplete: function(id, fileName, responseJSON){
				updateImages();
				$('#item_upload .qq-upload-list').empty();
			}
		});

		function format(el) {
			var regExp = /([^(]+)\(([^)]+)\)/;
			var matches = regExp.exec(el.text);
			return (matches == null || matches[2] == '') ? el.text : matches[1] + "<small>" + matches[2] + "</small>";
		}

		$('#select_feature_id').select2({
			formatResult: format,
			formatSelection: format,
			width: '100%'
		});

		$('#btn-add-feature').click(function(e){
			e.preventDefault();
			$.ajax({
				type: "POST",
				url: '/admin/catalog/addItemFeature/{/literal}{$item.item_id}{literal}',
				data: {feature_id: $('#select_feature_id').val(), value: ''},
				success: function(data) {
					if (data == 'true') {
						var target = $('#features_table tbody');
						var selText = $('#select_feature_id').select2('data').text;
						var selID = $('#select_feature_id').val();

						var regExp = /([^(]+)\(([^)]+)\)/;
						var matches = regExp.exec(selText);

						var res = (matches == null) ?
							"<tr rel=\"" + selID + "\"><td width=\"40%\">" + selText + "</td>" +
							"<td><input name=\"feature[" + selID + "]\" value=\"\" type=\"text\" class=\"form-control\"></td>" +
							"<td><button class=\"btn btn-default btn-small delete-feature\" type='button' value=\"" + selID + "\" title=\"Удалить характеристику товара\"><i class=\"fa fa-times\"></i></button></td></tr>"
								:
							"<tr rel=\"" + selID + "\"><td width=\"40%\">" + matches[1] + "</td>" +
							"<td><div class=\"input-group\"><input name=\"feature[" + selID + "]\" value=\"\" type=\"text\" class=\"form-control\"><span class=\"input-group-addon\">" + matches[2] + "</span></div></td>" +
							"<td><button class=\"btn btn-default btn-small delete-feature\" type='button' value=\"" + selID + "\" title=\"Удалить характеристику товара\"><i class=\"fa fa-times\"></i></button></td></tr>";

						target.append(res);
					}
				}
			});
		});

		$("#features_table").on('click', '.delete-feature', function(e){
			e.preventDefault();
			if (confirm('Вы действивтельно хотите удалить данную характеристику товара?')) {
				var fid = $(this).val();
				$.ajax({
					type: "POST",
					url: '/admin/catalog/deleteItemFeature/{/literal}{$item.item_id}{literal}',
					data: {feature_id: $(this).val()},
					success: function(data) {
						$('tr[rel=' + fid + ']').remove();
					}
				});
			};
		});

		$("#cloneTarget a").click(function(e) {
			e.preventDefault();
			if (confirm('Текущие характеристики будут заменены на характеристики выбранного товара. Подтверждаете?')) {
				var rel = $(this).attr('rel');
				$.ajax({
					type: "POST",
					url: '/admin/catalog/cloneFeatures/{/literal}{$item.item_id}{literal}',
					dataType: 'json',
					data: {from_id: rel},
					success: function(data) {
						if (data) {
							var target = $('#features_table tbody').empty();
							$.each(data, function(i, feature){
								var res = (feature.unit == null || feature.unit == "") ?
								"<tr rel=\"" + feature.feature_id + "\"><td width=\"40%\">" + feature.title + "</td>" +
								"<td><input name=\"feature[" + feature.feature_id + "]\" value=\"" + feature.feature_value + "\" type=\"text\" class=\"form-control\"></td>" +
								"<td><button class=\"btn btn-default btn-small delete-feature\" type='button' value=\"" + feature.feature_id + "\"  title=\"Удалить характеристику товара\"><i class=\"fa fa-times\"></i></button></td></tr>"
										:
								"<tr rel=\"" + feature.feature_id + "\"><td width=\"40%\">" + feature.title + "</td>" +
								"<td><div class=\"input-group\"><input name=\"feature[" + feature.feature_id + "]\" value=\"" + feature.feature_value + "\" type=\"text\" class=\"form-control\"><span class=\"input-group-addon\">" + feature.unit + "</span></div></td>" +
								"<td><button class=\"btn btn-default btn-small delete-feature\" type='button' value=\"" + feature.feature_id + "\"  title=\"Удалить характеристику товара\"><i class=\"fa fa-times\"></i></button></td></tr>";

								target.append(res);
							});

						}
					}
				});
			}
		});

	});
</script>
{/literal}