<!-- Top Bar
============================================= -->
<div id="top-bar" class="hidden-xs">

	<div class="container clearfix">

		<div class="col_half nobottommargin">
			<p class="nobottommargin"><strong>Горячая линия:</strong> {$contactPhone}</p>
		</div>

		<div class="col_half col_last fright nobottommargin">

			<!-- Top Links
			============================================= -->
			<div class="top-links">
				<ul>
					{if $user->logged == true}
					<li>
						<a href="/my/cart" id="directCartLink"><i class="icon-cart"></i> Корзина пуста</a>
					</li>
					{/if}
					<li>

						{if $user->logged == false}
						<a href="/my/" >Вход в кабинет</a>
						<div class="top-link-section">
							{include file="my-ajaxloginform.tpl"}
						</div>
					{else}
						<a href="#" >{if $user->account->name != ''}{$user->account->name}{else}{$user->account->email}{/if}</a>
						<ul role="menu">
							<li><a href="/my/" >Кабинет</a></li>
							<li><a href="/my/cart" class="cartLink">Корзина <span class="badge pull-right cartNum" style="margin-top: 9px;">0</span></a></li>
							<li><a href="/my/orders">Заказы</a></li>
							<li><a href="/my/profile">Профиль</a></li>
							<li><a href="?logout">Выйти</a></li>
						</ul>
					{/if}
					</li>
				</ul>
			</div><!-- .top-links end -->
		</div>
	</div>
</div><!-- #top-bar end -->

<!-- Header
============================================= -->
<header id="header">

	<div id="header-wrap">

		<div class="container clearfix">

			<div id="primary-menu-trigger"><i class="icon-reorder"></i></div>

			<!-- Logo
			============================================= -->
			<div id="logo">
				<a href="/" class="standard-logo" data-dark-logo="/images/logo-dark.png"><img src="/images/logo.png" alt="NIKA"></a>
				<a href="/" class="retina-logo" data-dark-logo="/images/logo-dark@2x.png"><img src="/images/logo@2x.png" alt="NIKA"></a>
			</div><!-- #logo end -->

			<!-- Primary Navigation
			============================================= -->
			<nav id="primary-menu">

				<ul>
					<li {if $controller == 'catalog'}class="current"{/if}><a href="/catalog/"><div>Каталог</div><span>Вся продукция нашей компании</span></a>
						<ul>
							{assign var="mcat" value=$menucat.data}
							{section name="id" loop="$mcat"}
								<li><a href="/catalog/viewCategory/{$mcat[id].category_id}/{$mcat[id].category_title|transliterate|lower}/" title="{$mcat[id].category_alternative_title}"><div>{$mcat[id].category_title}</div></a></li>
							{/section}
							<li><hr/></li>
							<li><a href="/catalog/commission/"><div>Коммиссионный отдел</div></a></li>
						</ul>
					</li>
					<li {if $controller == 'news'}class="current"{/if}><a href="/news/" ><div>Новости</div></a></li>
					<li {if $controller == 'about'}class="current"{/if}><a href="/about/" ><div>О компании</div></a></li>
					<li {if $controller == 'contacts'}class="current"{/if}><a href="/contacts/"><div>Контакты</div></a></li>
				</ul>

				<!-- Top Cart
				============================================= -->
				<div id="top-cart">
					<a href="/my/cart" id="top-cart-trigger"><i class="icon-shopping-cart"></i>{if $cartItems > 0}<span class="cartNum">{$cartItems}</span>{/if}</a>
					{if $user->logged != false}
					<div class="top-cart-content">
						<div class="top-cart-title">
							<h4>Корзина</h4>
						</div>
						<div class="top-cart-items">
							{section name=i loop=$cartData}
								<div class="top-cart-item clearfix">
									<!--div class="top-cart-item-image">
										<a href="#"><img src="images/shop/small/1.jpg" alt="Blue Round-Neck Tshirt"></a>
									</div-->
									<div class="top-cart-item-desc">
										<a href="#">{$cartData[i].item_title}</a>
										<span class="top-cart-item-price">{$cartData[i].price} руб.</span>
										<span class="top-cart-item-quantity">x{$cartData[i].quantity}</span>
									</div>
								</div>
							{sectionelse}
								Корзина пуста
							{/section}
						</div>
						<div class="top-cart-action clearfix">
							<span class="fleft top-checkout-price">{$cartTotal|replace:".00":""} руб.</span>
							<button onclick="document.location.href='/my/cart';" class="button button-3d nomargin fright button-mini">Открыть</button>
						</div>
					</div>
					{/if}
				</div><!-- #top-cart end -->

				<!-- Top Search
				============================================= -->
				<div id="top-search">
					<a href="#" id="top-search-trigger"><i class="icon-search3"></i><i class="icon-line-cross"></i></a>
					<form action="/catalog/search/" method="get">
						<input type="text" name="q" class="form-control" value="" placeholder="Наберите и нажмите Enter&hellip;">
					</form>
				</div><!-- #top-search end -->

			</nav><!-- #primary-menu end -->

		</div>

	</div>

</header><!-- #header end -->
