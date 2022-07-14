{* 
  Template {content_content_list} 
  Created by {RayZ}
  Date {12.10.2010}
*}

<table class="list">
	<tr>
		<th>Заголовок</th>
		<th class="w100">Действия</th>
	</tr>
	{assign var="cid" value="0"}
	{section name="id" loop="$content"}
	{if $cid != $content[id].category_id}
	<tr>
		<td colspan="2" class="subtitle">{$content[id].category_title}</td>
	</tr>
	{assign var="cid" value="`$content[id].category_id`"}
	{/if}

	<tr>
		<td><a href="#" onclick="editContent({$content[id].content_id});return false;">{$content[id].content_title}</a></td>
		<td class="center w100">
	    	<a href="#" class="ico ico-edit button" onclick="editContent({$content[id].content_id});return false;" title="Изменить"></a>
		</td>
	</tr>
	{sectionelse}
	<tr>
		<td colspan="2" class="empty">Данные отстствуют</td>
	</tr>
	{/section}
</table>