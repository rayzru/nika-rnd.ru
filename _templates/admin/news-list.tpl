<div class="btn-toolbar pull-right" role="toolbar" style="margin-top: 2em;">
	<a href="/admin/news/add" class="btn btn-success"><i class="fa fa-plus"></i> Добавить новость</a>
</div>
<h1>Новости</h1>

<table class="table table-hover">
	<thead>
	<tr>
		<th>Заголовок</th>
		<th style="width: 120px;">Дата</th>
		<th></th>
	</tr>
	</thead>
	<tbody>
	{section name="i" loop="$news"}

	<tr>
		<td><a href="/admin/news/edit/{$news[i].content_id}">{$news[i].content_title}</td>
		<td>{$news[i].content_date|date_format:"%d %m %Y"}</td>
		<td class="text-right">
			<a href="/admin/news/edit/{$news[i].content_id}" class="btn btn-xs btn-default" title="Редактировать"><i class="fa fa-edit"></i></a>
			<a href="/admin/news/delete/{$news[i].content_id}" class="btn btn-xs btn-danger" title="Удалить" onclick="return confirm('Действительно удалить новость?');"><i class="fa fa-times"></i></a>
		</td>
	</tr>
	{/section}
	</tbody>
</table>

