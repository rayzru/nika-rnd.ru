<ol class="breadcrumb">
	<li><a href="/admin">Главная</a></li>
	<li class="active">Пакетные операции</li>
</ol>

<h1>Операции</h1>
<div class="row">
	<div class="col-md-4" id="step1">
		<div class="form-group">
			<label for="articuls">Введите перечень артикулов</label>
			<textarea rows="4" name="data" id="articuls" class="form-control" style="width: 100%;"></textarea>
		</div>

		<div class="form-group">
			<button type="button" onclick="parseArticuls(); return false;" class="btn btn-default" data-loading-text="Ведется обработка...">Обработать</button>
		</div>

		<div class="form-group">
			<p><i class="fa fa-file-excel-o"></i> Загрузить файл нуменкулатуры в формате .XLS</p>
			<div id="articul_upload"></div>
		</div>
	</div>
	<div class="col-md-9 " id="step2"></div>
	<div class="col-md-3 step3" id="step3" style=""></div>
	<div class="col-md-3 step4" id="step4" style="">
		<div class="form-group">
			<input type="hidden" name="ids" value="" id="items_ids">
			<select id="op_select" data-width="100%" data-title="Выберите операцию">
				<option selected="selected"></option>
				<optgroup label="Видимость на сайте">
					<option value="hidden">Скрыть</option>
					<option value="visible">Показать</option>
				</optgroup>
				<optgroup label="Предупреждение о розничной цене">
					<option value="price_warn">Показывать</option>
					<option value="price_notwarn">Не показывать</option>
				</optgroup>
				<optgroup label="Наличие">
					<option value="available">Есть в наличии</option>
					<option value="temp">Временно недоступно</option>
					<option value="unavailable">Заказ</option>
				</optgroup>
				<optgroup label="Удаление">
					<option value="delete">Удалить товары</option>
				</optgroup>
			</select>
		</div>
		<div class="form-group">
			<button class="btn btn-primary" type="button" onclick="proceedOperation($('#items_ids').val(), $('#op_select').val()); return false;">Продолжить</button>
			<button class="btn btn-default" type='button' onclick="proceedCancel();">Отмена</button>
		</div>
	</div>
</div>

{literal}
<script type="application/ecmascript">
	$(function(){$('#op_select').selectpicker();});
	$('#step4, #step3').hide();

	uploader = new qq.FileUploader({
		element: document.getElementById('articul_upload'),
		action: '/admin/uploadXLS.php',
		sizeLimit: 0, // max size
		minSizeLimit: 0, // min size
		debug: false,
		params: {},
		multiple: false,
		onComplete: function(id, fileName, responseJSON){
			if (responseJSON.action == 'changePrices') {
				proceedPrices(fileName, responseJSON);
			} else if (responseJSON.action == 'changeNames') {
				proceedNames(fileName, responseJSON);
			}
		}
	});

	function proceedPrices2(filename) {
		$.ajax({
			url: '/admin/other/changePrices/',
			dataType: 'json',
			data: {
				'filename': filename
			},
			success : function(data) {
				if (data.success) {
					showNotify('Цены обновлены');
					$('#step2, #step3').empty();
					$('#step1').show();
				}
			}
		});
	}

	function proceedPrices(filename, data) {
		table = document.createElement('table');
		$(table).append("<thead><tr><th>Товар</th><th>Старая цена</th><th>Новая цена</th></tr></thead>");
		$(table).addClass('table')
		$(data.items).each(function(index, el){
			$(table).append("<tr><td>" + el.item_title + "</td><td class='strikeout right'>" + el.price + "</td><td class='right'>" + el.newprice + "</td></tr>");
		});

		$('#step1').hide();
		$('#step2').append(table);
		$('#step3').append("<button type='button' class='btn btn-primary' onclick='proceedPrices2(\"" + data.filename + "\");'>Продолжить</button>&nbsp;<button type='button' class='btn btn-default' onclick=\"proceedCancel();\">Отмена</button></div>").show();
	}

	function proceedCancel() {
		$('#step2,#step3').empty();
		$('#step3, #step4').hide();
		$('#step1').show();
	}

	function proceedNames2(filename) {
		$.ajax({
			url: '/admin/other/changeNames',
			dataType: 'json',
			data: {
				'filename': filename
			},
			success : function(data) {
				if (data.success) {
					alert('Наименования обновлены');
					proceedCancel();
				}
			}
		});
	}


	function parseArticuls() {
		$.ajax({
			url: '/admin/other/parseArticuls/',
			dataType: 'json',
			type: 'POST',
			data: {
				articuls:$('#articuls').val()
			},
			success : function(data, textStatus, obj) {
				var x = data;
				if (textStatus == 'success') {
					if (x.items.length > 0) {
						$('#items_ids').val(x.ids);
						table = document.createElement('table');
						tbody = document.createElement('tbody');
						$(table).addClass('table').append("<thead><tr><th>Наименование товара</th><th></th></tr></thead>");
						$(x.items).each(function(index, el){
							$(tbody).append("<tr><td>" + el.item_title + "</td><td width='20' style='text-align: right;'><a href='/catalog/viewItem/" + el.item_id + "' class='btn btn-default btn-xs'><i class='fa fa-link'></i></a></td></tr>");
						});
						$(table).append(tbody);

						$('#step1').hide();
						$('#step2').append(table).show();
						$('#step4').show();
					} else {
						showNotify('Товары с указанными артикулами не найдены', 'danger')
					}

				}

			}
		});
	}

	function proceedOperation(ids, operation) {
		$.ajax({
			url: '/admin/other/operate/',
			dataType: 'json',
			type: 'POST',
			data: {
				'articuls'	: ids,
				'operation'	: operation
			},
			success : function(data) {
				if (data.success) {
					showNotify(data.message);
					proceedCancel();
				}
			}
		});
	}

	function proceedNames(filename, data) {
		table = document.createElement('table');
		$(table).append("<thead><tr><th>Товар</th><th>Новое наименование</th></tr></thead>");
		$(table).addClass('table')
		$(data.items).each(function(index, el){
			$(table).append("<tr><td>" + el.item_title + "</td><td>" + el.newname + "</td></tr>");
		});

		$('#step1').hide();
		$('#step2').append(table);
		$('#step3').append("<button class='btn btn-success' type='button' onclick='proceedNames2(\"" + data.filename + "\");'>Продолжить</button> <button class='btn btn-default' type='button' onclick=\"proceedCancel();\">Отмена</button></div>").show();
	}

</script>
{/literal}