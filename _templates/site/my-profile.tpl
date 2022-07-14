{include file="page-title.tpl" title="Профиль" }

<section id="content" class="content-wrap">
	<div class="container">
		<div class="col_half">
				<div class="promo promo-border promo-mini">
					<form method="post" class="form-horizontal" role="form" style="margin-bottom: 0;">
						<h3 class="bottommargin-sm">{$user->account->email}</h3>
						<label for="inputName">Имя</label>
						<input type="text" class="sm-form-control bottommargin-sm" id="inputName" placeholder="Ф.И.О." required="required" autocomplete="off" name="name"  value="{$user->account->name}">

						<label for="inputPhone">Телефон</label>
						<input type="text" class="sm-form-control" id="inputPhone" placeholder="Ваш контактный телефон" autocomplete="off" name="phone"  value="{$user->account->phone}">

						<button type="button" class="button button-small button-light button-white topmargin-sm noleftmargin passCtlTrigger" onclick="$('.passCtl, .passCtlTrigger').toggle();return false;">Изменить пароль</button>

						<div class="passCtl topmargin-sm ">
							<div class="col_half">
								<label for="inputPass">Пароль</label>
								<input type="password" class="sm-form-control" id="inputPass" placeholder="Пароль" name="password" autocomplete="off">
							</div>
							<div class="col_half col_last">
								<label for="inputPass2">Подтверждение</label>
								<input type="password" class="sm-form-control" id="inputPass2"  name="password2" placeholder="Подтверждение пароля"  autocomplete="off">
							</div>

							<a href="#" class="btn btn-default btn-sm togglePassText" data-toggle="button"><i class="icon-lock"></i> Показать</a>
							<a href="#" class="btn btn-default btn-sm genPassword" data-loading-text="Создание..." title="Создать новый звучный пароль">Сочинить новый пароль</a>

						</div>

						<button type="submit" class="button noleftmargin topmargin-sm">Сохранить</button>

					</form>
				</div>
			</div>
			<div class="col-md-4">
				<h3>Контактные данные</h3>
				<p>Ваши данные никогда не будут использоваться в каких-либо целях. Они могут пригодится только для обратной связи наших менеджеров с вами по поводу ваших заказов.</p>

				<h3>Изменение пароля</h3>
				<p>Если вы не укажите пароль, то он останется прежним. Во избежание ситуаций, которые могут скомпроментировать ваши данные, никому не показывайте свой пароль.</p>
			</div>
			<div class="col-md-4">

			</div>
		</div>


	</div>
</section>


{literal}
	<script type="application/javascript">
		// ----- Setup: add dummy password text field and add toggle button
		$('input[type=password]').each(function(){
			var el = $(this);
			el.before('<input type="text" class="sm-form-control passText hide" placeholder="Пароль небыл создан" />');
		});

		// ----- keep text in sync
		$('input[type=password]').keyup(function(){
			var elText = $(this).val();
			$('.passText').val(elText);
		});

		$('.passText').keyup(function(){
			var elText = $(this).val();
			$('input[type=password]').val(elText);
		});

		// ----- Toggle button functions
		$('a.togglePassText').click(function(e){
			$('input[type=password], .passText').toggleClass("hide");
			e.preventDefault();
		});

		$('a.genPassword').click(function(e){
			$('a.genPassword').button('loading');
			$.ajax({
				url: "/my/genPassword",
				dataType: 'text'
			})
					.done(function( data ) {
						$('input[type=password], .passText').val(data);
						$('a.genPassword').button('reset');
					});
			e.preventDefault();
		});

	</script>
{/literal}