{include file="page-title.tpl" title="Регистрация на сайте" }

<section id="content" class="content-wrap">
	<div class="container">

		<div class="row">
			<div class="col-md-6">

				<h3>Регистрация</h3>

				{if isset($errors)}
					<div class="style-msg2 errormsg">
						<div class="msgtitle">Ошибка регистрации</div>
						<div class="sb-msg">
							<ul>
								{section name=id loop=$errors}
									<li>{$errors[id]}</li>
								{/section}
							</ul>
						</div>
					</div>
				{/if}

				<form method="post" role="form">
					<div class="col_full">
						<label for="inputEmail">Email</label>
						<input type="email" class="sm-form-control" id="inputEmail" placeholder="Email" required="required" autocomplete="off" name="email" value="{$register.email}">
					</div>
					<div class="col_full">
						<label for="inputName">Имя</label>
						<input type="text" class="sm-form-control" id="inputName" placeholder="Ф.И.О." required="required" autocomplete="off" name="name"  value="{$register.name}">
					</div>
					<div class="col_full">
						<label for="inputPhone">Телефон</label>
						<input type="text" class="sm-form-control" id="inputPhone" placeholder="Контактный телефон" autocomplete="off" name="phone"  value="{$register.phone}">
					</div>
					<div class="col_half">
						<label for="inputPass">Пароль</label>
						<input type="password" class="sm-form-control" id="inputPass" placeholder="Пароль" name="password" autocomplete="off" required="required">
					</div>

					<div class="col_half col_last">
						<label for="inputPass2">&nbsp;</label>
						<input type="password" class="sm-form-control" id="inputPass2"  name="password2" placeholder="Подтверждение пароля"  autocomplete="off" required="required">
					</div>

					<div class="col_full">
						<label>
							<input name="argeegment" type="checkbox" required="required" name="agree"> Я прочитал и принимаю все условия <a href="/my/agreement/" title="Открыть пользовательское соглашение в новоем окне">пользовательского соглашения</a>.
						</label>
					</div>

					<div class="col_full" style="margin-bottom: 0;">
						<button type="submit" class="button button-green">Зарегистрироваться</button>
					</div>

				</form>
			</div>
			<div class="col-md-6">
				<h3>Зачем нужна регистрация?</h3>
				{include file="my-whyregister.tpl"}
				<h3>Политика конфидециональности</h3>
				{include file="my-terms.tpl"}
			</div>
		</div>

	</div>
</section>

