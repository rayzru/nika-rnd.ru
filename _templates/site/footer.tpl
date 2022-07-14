<!-- Footer
============================================= -->
<footer id="footer" class="dark">

	<div class="container">

		<!-- Footer Widgets
		============================================= -->
		<div class="footer-widgets-wrap clearfix">

			<div class="col_one_third">

				<div class="widget clearfix">

					<img src="/theme/images/logo-dark.png" alt="" class="footer-logo">

					<p>Поставка промышленного оборудования</p>

				</div>
			</div>


			<div class="col_one_third">

				<div class="widget widget_links clearfix">

					<ul>
						<li><a href="/about/">О компании</a></li>
						<li><a href="/news/">Новости</a></li>
						<li><a href="/articles/">Полезные статьи</a></li>
						<li><a href="/my/">Ваш личный кабинет</a></li>
						<li><a href="/contacts/">Как с нами связаться?</a></li>
					</ul>

				</div>

			</div>

			<div class="col_one_third col_last">
				<div class="counter counter-small"><span data-from="0" data-to="{$totalItems}" data-refresh-interval="80" data-speed="1000" data-comma="false">{$totalItems}</span></div>
				<h5 class="nobottommargin">{$totalItems|plural:"товар":"товара":"товаров"} в каталоге</h5>
			</div>

		</div><!-- .footer-widgets-wrap end -->

	</div>

	<!-- Copyrights
	============================================= -->
	<div id="copyrights">

		<div class="container clearfix">

			<div class="col_half">
				&copy;&nbsp;<script>document.write(new Date().getFullYear())</script>. Все права принадлежат компании НИКА.<br>
				<div class="copyright-links">
					<a href="/my/agreement">Соглашение использования</a> | Сайт разработан в <a href="http://rayz.ru">RayZ.ru</a>
				</div>
			</div>

			<div class="col_half col_last">
				<h3 class="tright">{$contactPhone}</h3>
			</div>

		</div>

	</div><!-- #copyrights end -->

</footer><!-- #footer end -->

</div><!-- #wrapper end -->

<!-- Go To Top
============================================= -->
<div id="gotoTop" class="icon-angle-up"></div>

<!-- Footer Scripts
============================================= -->
<script type="text/javascript" src="/theme/js/functions.js"></script>

</body>
</html>