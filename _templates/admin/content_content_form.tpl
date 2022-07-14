<div class="form mt10">

	<form action="" method="post" id="content_form">
		<input type="hidden" name="mod" value="content">
		<input type="hidden" name="action" value="content_form">
		<input type="hidden" name="content_id" value="" id="content_id">
		<input type="hidden" name="content_label" value="" id="content_label_data">

		<div class="mt20">
			<label for="content_title">Заголовок</label>
			<input type="text" value="" name="content_title" id="content_title" class="w100p bigtext">
		</div>

		<div class="mt20">
			<label for="content_label">Маркер</label>
			<input type="text" value="" disabled="disabled" readonly="readonly" id="content_label" class="w100p text">
		</div>

		<div class="mt20">
			<label for="content_text">Текст</label>
			<textarea rows="10" cols="80" class="tinymce" name="content_text" id="content_text" style="width:100%;">{$content.content_text}</textarea>
		</div>
	</form>

	{if isset($err)}
		<div class="errors">
			<ul>
			{section name=id loop=$err}
				<li>{$err[id]}</li>
			{/section}
			</ul>
		</div>
	{/if}
</div>