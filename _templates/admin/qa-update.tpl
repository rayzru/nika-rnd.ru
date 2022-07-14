<ol class="breadcrumb">
	<li><a href="/admin">Главная</a></li>
	<li><a href="/admin/qa/">Вопросы-ответы</a></li>
	<li class="active">Обновление</li>
</ol>

<div class="modal fade" tabindex="-1" id="mailModal" role="dialog" aria-labelledby="myModalLabel" aria-hidden="false">
	<div class="modal-dialog modal-lg">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Закрыть</span></button>
				<h4 class="modal-title">Ответ на вопрос письмом</h4>
			</div>
			<div class="modal-body">
				<div class="form-group">
					<textarea class="form-control" id="mailText" name="answer" rows="20" style="height:300px;"><h2>Уважаемый(ая) {$qa.name}!</h2>Вы спрашивали: <blockquote>{$qa.question}</blockquote> Отвечаем:<br/></textarea>
				</div>

				<button type="button" class="btn btn-default pull-right" data-dismiss="modal">Закрыть</button>
				<button type="button" class="btn btn-success" id="sendMail" data-loading-text="<i class='fa fa-reload fa-spin'></i> Отправка..."><i class="fa fa-envelope-o"></i> Отправить ответ</button>
				&nbsp;<div class="checkbox-inline"><label><input type="checkbox" value="" name="delete" id="deleteCheckbox"> и удалить вопрос</label></div>
			</div>
		</div><!-- /.modal-content -->
	</div><!-- /.modal-dialog -->
</div><!-- /.modal -->

<h1>Вопрос {$qa.id} <small>от {$qa.published_date|date_format:"%d %m %Y"} <i class="fa fa-link"></i> <a href="/catalog/viewItem/{$qa.item_id}" target="_blank" title="Открыть товар в новом окне">{$qa.item_title}</a></small></h1>

<form method="post" role="form">
<input type="hidden" value="{$qa.id}" name="id" id="qa_id">
<input type="hidden" value="{$qa.email}" name="email" id="qa_email">
<input type="hidden" value="{$qa.name}" name="name" id="qa_name">

<div class="row">
	<div class="col-md-8">
		<div class="question">
			<h4 style="line-height: 1.5em;">{$qa.question}</h4>
			<div class="form-group question-group" style="display: none;">
				<textarea rows="10" class="wysiwyg form-control" name="question">{$qa.question}</textarea>
			</div>

			<div class="form-group">
				<button type="button" class="btn btn-default btnedit" onclick="$('.question h4, .question .question-group, .question .btnedit').toggle();$('.wysiwyg').wysihtml5({*ldelim}locale:"ru-RU"{rdelim*});return false;">Редактировать вопрос</button>
				<a href="/admin/qa/delete/{$qa.id}" class="btn btn-danger" onclick="return confirm('Вы действительно хотите удалить текущий вопрос безвозвратно?');">Удалить вопрос</a>
			</div>
		</div>

		<h2>Ответ</h2>

		<div class="form-group">
			<textarea class="form-control" name="answer" rows="10">{$qa.answer}</textarea>
		</div>

		<div class="form-group">
			<a href="/admin/qa/" class="btn btn-default pull-right">Вернуться к списку</a>

			<button type="submit" class="btn btn-success ">Сохранить, ответить</button>

			{if $qa.email != ''}<a href="#mailModal" class="btn btn-default" data-toggle="modal"><i class="fa fa-envelope-o"></i> Ответить письмом</a>{/if}

			&nbsp;<div class="checkbox-inline">
				<label><input type="checkbox" value="" name="resolve" checked="checked"> Закрыть вопрос</label>
			</div>
		</div>

	</div>

	<div class="col-md-4">

		<div class="well">
			<h4><i class="fa fa-user"></i> {$qa.name}</h4>
			<p>{$qa.email}</p>
			<p>{$qa.address}</p>
		</div>

		<div class="form-group">
			<div class="btn-group btn-group-justified" data-toggle="buttons">
				<label class="btn btn-default {if $qa.status == 'queued'}active{/if}">
					<input type="radio" name="status" value="queued" {if $qa.status == 'queued' || $qa.status == ''}checked="checked"{/if}> Ожидает ответа
				</label>
				<label class="btn btn-default {if $qa.status == 'closed'}active{/if}">
					<input type="radio" name="status" value="closed" {if $qa.status == 'closed'}checked="checked"{/if}> Закрыт
				</label>
			</div>
		</div>

		<div class="form-group">
			<div class="btn-group btn-group-justified" data-toggle="buttons">
				<label class="btn btn-default {if $qa.active == 1}active{/if}">
					<input type="radio" name="active" value="1" {if $qa.active == 1}checked="checked"{/if}> Показывать
				</label>
				<label class="btn btn-default {if $qa.active == 0}active{/if}">
					<input type="radio" name="active" value="0" {if $qa.active == 0}checked="checked"{/if}> Скрыть
				</label>
			</div>
		</div>
	</div>
</div>
</form>
{literal}
<script type="application/ecmascript">
	var mailEditor = false;
	$(function(){

		var statuses = getParameterByName('s').split(',');
		if (statuses != '') $(statuses).each(function(k,v){
			$('input[value=' + v + ']').attr('checked', 'checked').parent().addClass('active');
		});

		if (statuses == '') $('input[value="queued"]').attr('checked', 'checked').parent().addClass('active');


		$('#mailModal').on('show.bs.modal', function (e) {
			mailEditor = mailEditor || $('#mailText').wysihtml5({locale:"ru-RU"});
			//var data = $('#mailText').val();
			//$('#mailText').focus().val('').val(data);
		});

		$('#sendMail').on('click', function(e){
			$('#sendMail').button('loading');
			var data = {
				content: $('#mailText').val(),
				email: $('#qa_email').val(),
				delete: $('#deleteCheckbox').is(':checked'),
				id: $('#qa_id').val()
			};

			$.post('/admin/qa/mailAjax', data, function(response) {
				if (response != 'ok') {
					// error;
					$('#sendMail').button('reset');
					showNotify('Что-то пошло не так', 'danger');
				} else {

					if ($('#deleteCheckbox').is(':checked')) {
						document.location.href="/admin/qa/";
					} else {
						$('#sendMail').button('reset');
						$('#mailModal').modal('close');
					}
				}
			});
		});
	})
</script>
{/literal}