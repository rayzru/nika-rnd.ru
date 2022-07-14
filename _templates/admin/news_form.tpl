<form method="POST" id="item_form" action="" enctype="multipart/form-data">
	<input type="hidden" name="mod" value="qa"/>
	<input type="hidden" name="action" value="update"/>
	<input type="hidden" name="item_id" value="{$qa.item_id}"/>
	<input type="hidden" name="category_id" value="{$qa.category_id}"/>
	<input type="hidden" name="id" value="{$qa.id}"/>
	<h2>Редактирование вопроса</h2>

	<table class="w100p">
		<tr class="top">
			<td style="width:70%;">
				<label class="block" for="qa_title">Заголовок</label>
				<input type="text" class="w100p bigtext" value="{$qa.title}" name="qa_title" id="qa_title"/>

				<div class="mt20">
					<label for="qa_text">Вопрос</label>
					<textarea class="tinymce" name="qa_text" rows="5" style="width: 100%;" id="qa_text">{$qa.question}</textarea>
				</div>

				<div class="mt20">
					<label for="qa_answer">Ответ</label>
					<textarea class="tinymce" name="qa_answer" rows="5" style="width: 100%;" id="qa_answer">{$qa.answer}</textarea>
				</div>
			</td>
			<td class="pl20"  style="width:30%;">
				<div class="">
					<label for="qa_name">Автор</label>
					<input type="text" class="w100p bigtext" value="{$qa.name}" name="qa_name" id="qa_name"/>
				</div>
				<div class="mt20">
					<label for="qa_email">Email</label>
					<input type="text" class="w100p bigtext" value="{$qa.email}" name="qa_email" id="qa_email"/>
				</div>
				<div class="mt20">
					<label for="qa_address" >Адрес</label>
					<input type="text" class="w100p " value="{$qa.address}" name="qa_address" id="qa_address"/>
				</div>
				<div class="mt50">
					<label  class="floatl">Дата вопроса</label>
					<input type="text"  class="w150 floatr" readonly="readonly" disabled="disabled" value="{$qa.published_date|date_format}"/>
				</div>
				<div class="clr"></div>
				<div class="mt20">
					<label for="qa_status" class="floatl">Статус</label>
					<select name="qa_status" id="qa_status" class="w150 floatr">
						<option value="new" {if $qa.status == 'new'}selected="selected"{/if}>Ожидает модерации</option>
						<option value="approved" {if $qa.status == 'approved'}selected="selected"{/if}>Подтвержден</option>
						<option value="suspended" {if $qa.status == 'suspended'}selected="selected"{/if}>Отложен</option>
						<option value="deleted" {if $qa.status == 'deleted'}selected="selected"{/if}>Удален</option>
					</select>
				</div>
				<div class="clr"></div>
				<div class="mt20">
					<label for="qa_active"  class="floatl">Видимость</label>
					<select name="qa_active" id="qa_active"  class="w150 floatr">
						<option value="1" {if $qa.active == 1}selected="selected"{/if}>Показывать</option>
						<option value="0" {if $qa.active == 0}selected="selected"{/if}>Скрыть</option>
					</select>
				</div>
				{if $qa.item_id != ''}
				<div class="clr"></div>

				<div class="mt20">
					вопрос относится к: <strong><a href="/catalog/?id={$qa.item_id}">{$qa.item_title}</a></strong>
				</div>
				{/if}
				<div class="clr"></div>
				<div class="mt50">
					<input type="submit" value="Сохранить"/>
				</div>
			</td>
		</tr>
	</table>


</form>
