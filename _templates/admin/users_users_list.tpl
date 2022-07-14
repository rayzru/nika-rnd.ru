<table class="list mt10">
<thead>
  <tr>
    <th>Пользователь</th>
    <th>Имя</th>
	  <th>E-Mail</th>
	  <th>Телефон</th>
    <th class="w200">Дата регистрации</th>
    <th class="w100">Действия</th>
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
