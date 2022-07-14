{include file="page-title.tpl" title="Запрос повторной активации" no_breadcrumbs=1}

<section id="content" class="content-wrap">
	<div class="container">
		<div class="row">
			<div class="col-md-4">
				<p>
					Вероятно, после регистрации активационное письмо было утреряно каким-то образом, поэтому вы не можете авторизоваться на нашем сайте. Давайте попробуем еще раз.
				</p>
				<p>
					Укажите почтовый адрес, который вы указывали при регистрации.
				</p>

			</div>
			<div class="col-md-4">
				<form method="post" role="form">
					<label for="inputEmail">Email</label>
					<input type="email" class="sm-form-control" id="inputEmail" placeholder="Email" required="required" autocomplete="off" name="email" value="{$register.email}">

					<button type="submit" class="button button-green noleftmargin">Выслать письмо</button>
				</form>
			</div>
		</div>

	</div>
</section>