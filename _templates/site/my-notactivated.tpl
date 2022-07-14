{include file="page-title.tpl" title="Ой, что-то пошло не так!" }

<section id="content" class="content-wrap">
	<div class="container">
		<div class="row">
			<div class="col-md-4">
				К сожалению ваша активация не может быть завершена. Либо эта ссылка уже использовалась, либо она не верна.
				Вы можете попробовать повторно запросить активационную ссылку на свой почтовый адрес, воспользовавшись формой справа.
			</div>
			<div class="col-md-4">
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

				<form method="post" action="/my/reactivate">
					<input type="email" value="" name="email" placeholder="E-Mail" class="sm-form-control" required="required">
					<button type="submit" class="button button-green">Запросить</button>
				</form>
			</div>
		</div>

	</div>
</section>