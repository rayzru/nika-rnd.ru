{if $action==''}
<div class="container">
	<a href="/admin/units/add/" class="btn btn-success">Добавить свойство</a>
	<table class="table">
		<tr>
			<th>#</th>
			<th>Свойство</th>
			<th>Единица измерения</th>
			<th class="text-right">Действия</th>
		</tr>

		{section name=id loop=$features}
			<tr>
				<td class="text-muted">{$smarty.section.id.iteration}</td>
				<td>{$features[id].title}</td>
				<td>{$features[id].unit}</td>
				<td class="text-right">
					<a href="/admin/units/edit/{$features[id].id}" class="btn btn-default btn-xs" title="Изменить"><i class="fa fa-edit"></i></a>
					<a href="/admin/units/delete/{$features[id].id}" class="btn btn-default  btn-xs" title="Удалить свойство из списка" onclick="return confirm('Вы действительно хотите удалить свойство?');"><i class="fa fa-times"></i></a>
				</td>
			</tr>
			{sectionelse}
			<tr>
				<td colspan="4" class="empty">Наборы свойств не назначены</td>
			</tr>
		{/section}
	</table>
</div>
{elseif $action=='edit' || $action=='add' }
	<div class="container">

		<h2>{if $action=='add'}Новое свойство{else}Изменение свойства{/if}</h2>

		<form method="POST" id="features_form">
			<input type="hidden" name="id" value="{$feature.id}">
			<div class="row">
				<div class="col-md-5">
					<div class="form-group">
							<label class="mt20" for="feature_title">Наименование</label>
							<input type="text" class="form-control" name="title" id="feature_title" value="{$feature.title}" />
					</div>
				</div>
				<div class="col-md-3">
					<div class="form-group">
						<label class="mt20" for="feature_unit">Еденица измерения</label>
						<input type="text" name="unit" class="form-control" id="feature_unit"  value="{$feature.unit}"/>
				</div>
				</div>
			</div>

			<div class="form-group">
				<button class="btn btn-primary" type="submit">Сохранить</button>
			</div>
		</form>
		</div>
	</div>
{/if}