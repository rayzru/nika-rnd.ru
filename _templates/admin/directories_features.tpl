<table class="list mt10">
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
    	<a href="#" class="ico ico-edit button" onclick="editFeature({$features[id].feature_id}, '{$features[id].feature_title|escape}', '{$features[id].feature_unit|escape}');return false;" title="Изменить"></a>
    	<a href="?mod=directories&action=delete_feature&id={$features[id].feature_id}" class="ico ico-delete button" title="Удалить свойство из списка" onclick="return confirm('Вы действительно хотите удалить свойство?');"></a>
    </td>
  </tr>
{sectionelse}
  <tr>
    <td colspan="4" class="empty">Наборы свойств не назначены</td>
  </tr>
{/section}
</table>