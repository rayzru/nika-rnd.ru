{if isset($errors) && !empty($errors)}
	<div class="alert alert-danger">
		<h4>Возникли ошибки</h4>
		<ul>{section name=id loop=$errors}<li>{$errors[id]}</li>{/section}</ul>
	</div>
{else}ok{/if}