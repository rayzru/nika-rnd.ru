<form class="ajaxAuth nobottommargin" action="/my/auth" method="post">
	<input type="hidden" name="method" value="ajax">
	<input name="username" type="text" placeholder="E-mail" class="sm-form-control" />

	<p>У вас нет аккаунта? Пройдите простую <a href="/my/register" class="">регистрацию</a>.</p>

	<input name="password" type="password" placeholder="Пароль"  class="sm-form-control " />

	<p><a href="/my/amnesia" class="">Забыли пароль?</a></p>

	<button type="submit" class="ajaxAuthButton button button-green noleftmargin nobottommargin" data-loading-text="<i class='fa fa-spinner fa-spin'></i> Авторизация...">Войти</button>
</form>