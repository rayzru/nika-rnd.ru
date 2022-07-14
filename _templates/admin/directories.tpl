<script type="text/javascript">
<!--
{if $action=='features'}
	{literal}
	$(function(){
		$('#features_add_Button, #features_cancel_Button').click(function(){
			$('.edit_mode, .view_mode').toggle();
			addFeature();
			return false;
		});

		$('#features_save_Button').click(function(){
			$('#features_form').submit();
		});
		
	});
	{/literal}
{/if}
		
//-->
</script>

<h2>Свойства товаров</h2>

{if $action=='features'}
<div class="control_panel topline">
	<div class="">
		<div class="view_mode">
			<a href="#" class="ico ico-greenplus button" id="features_add_Button">Добавить свойство</a>
		</div>
		<div class="edit_mode hide">
			<a href="#" class="ico ico-save button" id="features_save_Button">Сохранить</a>
			<a href="#" class="ico ico-cancel button" id="features_cancel_Button">Отмена</a>
		</div>
		
	</div>
	<div class='clr'></div>
</div>
	
<div id="features_list" class="view_mode">
	{include file="directories_features.tpl"}
</div>

<div id="feature_form" class="edit_mode hide">
	{include file="directories_feature_form.tpl"}
</div>
{/if}
