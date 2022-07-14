{include file="page-title.tpl" title="Мой кабинет" }

<section id="content" class="content-wrap">
	<div class="container">
		<div class="row">
			<div class="col_one_fourth bounceIn animated" data-animate="bounceIn">

				{if $cartItems == 0}
					<a href="/my/cart/"><i class="i-plain i-xlarge divcenter nobottommargin icon-cart"></i></a>
					<h5>Корзина пуста</h5>
				{else}
					<div class="counter counter-large">
						<a href="/my/cart/">
							<i class="i-plain i-xlarge divcenter nobottommargin icon-cart"></i>
							<span data-from="0" data-to="{$cartItems}" data-refresh-interval="50" data-speed="2000">{$cartItems}</span>
						</a>
					</div>
					<h5>товаров в корзине</h5>

					<a class="" href="/my/cart/">Открыть корзину</a>
				{/if}

				<a class="" href="/my/orders/">Aрхив заказов</a>

			</div>
			<div class="col_one_fourth bounceIn animated" data-animate="bounceIn">
				<a href="/my/profile/"><i class="i-plain i-xlarge divcenter nobottommargin icon-user2"></i></a>
				<div class="counter counter-small">
					{$user->account->name}
				</div>

				<ul class="iconlist">
					<li><i class="icon-email"></i> {$user->account->email}</li>
					{if !empty($user->account->phone)}<li class=""><i class="icon-phone"></i> {$user->account->phone}</li>{/if}

				</ul>

				<a href="/my/profile/">Редактировать профиль</a>
			</div>
			<div class="col_half col_last">
				<div class="promo promo-light promo-mini bottommargin">
					<h3>Звоните <span>+7 (863) 123-45-67</span> или пишите на <span class="text-nowrap">support@nika-rnd.ru</span></h3>
					<span>Если у вас возникли вопросы по заказу и оформлению товаров, доставке, наличию и сроках поставки, свяжитесь с нашими менеджерами по указанным контактам</span>
				</div>
			</div>

		</div>


	</div>
</section>