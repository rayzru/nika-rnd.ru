<div class="container">
	<form class="form-signin" method="post" action="/admin/auth">
		<h2 class="form-signin-heading">Посторонним В.</h2>
		<div class="form-group"><input name="login" type="text" class="form-control" placeholder="Логин" required autofocus></div>
		<div class="form-group"><input name="password" type="password" class="form-control" placeholder="Пароль" required></div>
		<button class="btn btn-lg btn-primary btn-block" type="submit">Войти</button>

		{if isset($error)}<div class="text-danger alert alert-danger" style="margin-top: 2em;">{$error}</div>{/if}
		<div class="text-muted text-center" style="margin-top: 2em;">Ваш IP: <b>{$ip}</b></div>
	</form>
</div>
