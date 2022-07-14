<table class="list mt10">
  <tr>
    <th class="w20">*</th>
    <th>Свойство</th>
    <th>Единица измерения</th>
    <th>Действия</th>
  </tr>

{section name=id loop=$features}
  <tr>
    <td><a class="ico {if $features[id].marked=='true'}ico-star{else}ico-star-grayed{/if}" href="?mod=catalog&action=mark_toggle&cid={$cid}&feature_id={$features[id].id}">&nbsp;</div></td>
    <td>{$features[id].feature_title}</td>
    <td>{$features[id].feature_unit}</td>
    <td>
    	<a href="?mod=catalog&action=mark_toggle&cid={$cid}&feature_id={$features[id].id}" class="ico ico-star button" title="Переключить метку"></a>
    	<a href="?mod=catalog&action=category_feature_remove&cid={$cid}&feature_id={$features[id].id}" class="ico ico-delete button" title="Удалить свойство из списка"></a>
    </td>
  </tr>
{sectionelse}
  <tr>
    <td colspan="4" class="empty">Наборы свойств не назначены</td>
  </tr>
{/section}
</table>

{literal}
<script type="text/javascript">
$(function(){
	/*
	* Catalog features block
	*
	*/
	$('#features_add_Button, #features_cancel_Button').click(function(){
		$('#panel_features .edit_mode, #panel_features .view_mode, ').toggle();
		return false;
	});

	$('#features_save_Button').click(function(){
		$('#features_form').submit();
	});

});

</script>
{/literal}