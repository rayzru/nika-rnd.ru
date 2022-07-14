<div class="container">
	<table class="table">
		<tr>
			<th>Свойство</th>
			<th>Единица измерения</th>
			<th>Действия</th>
		</tr>

		{section name=id loop=$features}
			<tr>
				<td>{$features[id].feature_title}</td>
				<td>{$features[id].feature_unit}</td>
				<td>
					<a href="#" class="btn btn-default" onclick="editFeature({$features[id].feature_id}, '{$features[id].feature_title|escape}', '{$features[id].feature_unit|escape}');return false;" title="Изменить"><i class="fa fa-edit"></i></a>
					<a href="/admin/directories/delete/{$features[id].feature_id}" class="btn btn-default" title="Удалить свойство из списка" onclick="return confirm('Вы действительно хотите удалить свойство?');"><i class="fa fa-times"></i></a>
				</td>
			</tr>
			{sectionelse}
			<tr>
				<td colspan="4" class="empty">Наборы свойств не назначены</td>
			</tr>
		{/section}
	</table>
</div>
