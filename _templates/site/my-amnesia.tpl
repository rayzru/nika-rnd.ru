{include file="page-title.tpl" title="Восстановление доступа" }

<section id="content" class="content-wrap">
	<div class="container">
		<div class="row">
			<div class="col-md-5">
				<h3>Запросить доступ</h3>

				{if isset($errors)}
					<div class="style-msg2 errormsg">
						<div class="msgtitle">Ошибка</div>
						<div class="sb-msg">
							<ul>
								{section name=id loop=$errors}
									<li>{$errors[id]}</li>
								{/section}
							</ul>
						</div>
					</div>
				{/if}

				<form method="post" role="form" style="margin-bottom: 0;">
					<label for="inputEmail">Email</label>
					<input type="email" class="sm-form-control"  name="email" id="inputEmail" placeholder="Email" required="required">
					<button type="submit" class="button button-green noleftmargin topmargin-sm">Восстановить</button>
				</form>
			</div>
			<div class="col-md-7">
				<h3>Как восстановить доступ к кабинету?</h3>
				<p>Если вы потеряли свой пароль и не можете его вспомнить, то достаточно ввести свой Email, указанный при регистрации. На ваш ящик в течении 5 минут будет отправлена ссылка, перейдя по которой вы получите новый пароль.</p>

				<h4>Не говорите свой пароль никому</h4>
				<p>Ни в коем случае, ни под каким предлогом, никому не говорите свой пароль. Ни модераторам, ни представителям администрации он не нужен.</p>
			</div>
		</div>

	</div>
</section>