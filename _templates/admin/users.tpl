<table class="table usersTable">
	<thead>
	<tr>
		<th>Пользователь</th>
		<th>Имя</th>
		<th>E-Mail</th>
		<th>Телефон</th>
		<th>Дата регистрации</th>
		<th></th>
	</tr>
	</thead>
	{section name=id loop=$users}
		<tr>
			<td>{$users[id].login}</td>
			<td>{$users[id].name}</td>
			<td>{$users[id].email}</td>
			<td>{$users[id].phone}</td>
			<td>{$users[id].registered_date}</td>
			<td>

			</td>
		</tr>
		{sectionelse}
		<tr>
			<td colspan="5" class="empty">Пользователи не зарегистрированы</td>
		</tr>
	{/section}
</table>

<script type="text/javascript">
	{literal}
	$(function(){
		//$('.usersTable').dataTable();
	});
	{/literal}
</script>
