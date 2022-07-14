<script type="text/javascript">
<!--
{if $action=='content'}
	{literal}
	$(function(){
		$('#content_add_Button, #content_cancel_Button').click(function(){
			$('.edit_mode, .view_mode').toggle();
			return false;
		});

		$('#content_save_Button').click(function(){
			$('#content_form').submit();
		});

	});

	{/literal}
{/if}

//-->
</script>

{* <ul id="submenu">
	<li><a href="/admin/?mod=content&action=content" {if $action=="content"} class="current"{/if}>Текстовые блоки</a></li>
	 <li><a href="/admin/?mod=content&action=news" {if $action=="news"} class="current"{/if}>Новости</a></li>
	<li><a href="/admin/?mod=content&action=articles" {if $action=="articles"} class="current"{/if}>Статьи</a></li>
	<li><a href="/admin/?mod=content&action=settings" {if $action=="settings"} class="current"{/if}>Настройки</a></li>
</ul> *}

{if $action=='content'}
<div class="">
	<div class="mt10">
		<div class="view_mode">
			<h2>Текстовые блоки</h2>
		</div>
		<div class="edit_mode hide">
			<a href="#" class="ico ico-save button" id="content_save_Button">Сохранить</a>
			<a href="#" class="ico ico-cancel button" id="content_cancel_Button">Отмена</a>
		</div>

	</div>
	<div class='clr'></div>
</div>

<div id="features_list" class="view_mode">
	{include file="content_content_list.tpl"}
</div>

<div id="feature_form" class="edit_mode hide">
	{include file="content_content_form.tpl"}
</div>
{/if}
