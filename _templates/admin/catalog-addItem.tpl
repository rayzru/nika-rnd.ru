<form method="POST" id="item_form" action="" enctype="multipart/form-data">
	<h3>Добавление товара</h3>

	<div class="form-group">
		<div class="row">
			<div class="col-md-9">
				<label class="" for="item_title">Наименование</label>
				<input type="text" class="form-control" value="" name="item_title" id="item_title"/>
			</div>
			<div  class="col-md-3">
				<label for="item_key">Артикул</label>
				<input type="text" class="form-control" value="" name="item_key" id="item_key"/>
			</div>
		</div>
	</div>
	<div class="form-group">
		<label class="block" for="item_alt_title">Альтернативное наименование</label>
		<input type="text" class="form-control" value="" name="item_alt_title" id="item_alt_title"/>
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
		<textarea class="form-control" name="item_description" rows="10" id="item_description">{$item.item_description}</textarea>
	</div>

	<div class="form-group">
		<a href="/admin/catalog/viewItems/{$category.category_id}" class="btn btn-default">Отмена</a>
		<button type="submit" name="continue_editing" value="1" class="btn btn-success" title="Созранить настройки товара и остаться в форме редактирования">Применить</button>
		<button type="submit" class="btn btn-success">Сохранить</button>
	</div>

</form>

{literal}
<script type="application/ecmascript">
	$(function(){
		$('#item_description').wysihtml5({
			locale:"ru-RU",
			image: false,
			blockquote: false,
			html: true,
			parserRules: {tags:{a:{set_attributes:{target:"_self",rel:""}}}}
		});
	});
</script>
{/literal}