<div class="btn-toolbar pull-right" role="toolbar" style="margin-top: 2em;">
	<a href="/admin/articles/add" class="btn btn-success"><i class="fa fa-plus"></i> Добавить статью</a>
</div>
<h1>Статьи</h1>

<table class="table">
	<tbody>
	{section name=i loop=$articles}
		<tr><td colspan="2" style="border-bottom: 2px solid dodgerblue; padding-top: 2em;">
				<b>{$articles[i].category_title}</b>
			</td></tr>
		{section name=j loop=`$articles[i].articles_list`}
			<tr>
				<td>
					<a href="/admin/articles/edit/{$articles[i].articles_list[j].id}">{$articles[i].articles_list[j].article_title}</a>
				</td>
				<td class="text-right">
					<a href="/admin/articles/edit/{$articles[i].articles_list[j].id}" class="btn btn-default btn-xs"><i class="fa fa-edit"></i></a>
					<a href="/admin/articles/delete/{$articles[i].articles_list[j].id}" class="btn btn-default btn-xs" onclick="return confirm('Действительно удалить?');"><i class="fa fa-times"></i></a>
				</td>
			</tr>
		{/section}
		{sectionelse}
		<tr><td colspan="2" class="empty">Статьи отсутствуют</td></tr>
	{/section}
	</tbody>
</table>



