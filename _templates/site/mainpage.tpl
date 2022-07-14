<div class="hidden-lg hidden-md hidden-sm text-center">
	<a href="tel:{$contactPhone}"><h2>{$contactPhone}</h2></a>
</div>
<section id="slider" class="slider-parallax swiper_wrapper clearfix bottommargin-sm">
	<div class="swiper-container swiper-parent">
		<div class="swiper-wrapper">
			<div class="swiper-slide"">
				<div class="container clearfix">
					<div class="slider-caption slider-caption-center">
						<h2 data-caption-animate="fadeInUp">Промышленное оборудование</h2>
						<p data-caption-animate="fadeInUp" data-caption-delay="200">Поставляем промышленное оборудование от известных производителей во все уголки Южного Федерального Округа</p>
					</div>
				</div>
			</div>
		</div>
	</div>
{literal}
	<script>
		jQuery(document).ready(function ($) {
			var swiperSlider = new Swiper('.swiper-parent', {
				paginationClickable: false,
				slidesPerView: 1,
				grabCursor: false
			});
		});
	</script>
{/literal}
</section>

<section id="content" class="content-wrap">

	<div class="container">

		<div class="clear"></div>

		<div class="col_one_third catalog-promo catalog-promo-1">
			<a href="/catalog/viewCategory/1/holodilnoe-oborudovanie/">
				Холодильное оборудование
			</a>
		</div>
		<div class="col_one_third catalog-promo catalog-promo-2">
			<a href="/catalog/viewCategory/2/pischevoe-oborudovanie/">
				Пищевое оборудование
			</a>
		</div>
		<div class="col_one_third col_last catalog-promo catalog-promo-3">
			<a href="/catalog/viewCategory/27/fermerskoe-oborudovanie/">
				Фермерское оборудование
			</a>
		</div>

		<div class="clear"></div>

		<div class="col_one_fourth catalog-promo catalog-promo-4 ">
			<a href="/catalog/viewCategory/28/proizvodstvo-alkogolnoj-produkcii/">
				Производство алкогольной продукции
			</a>
		</div>
		<div class="col_one_fourth catalog-promo catalog-promo-5">
			<a href="/catalog/viewCategory/29/upakovochnoe-oborudovanie/">
				Упаковочное оборудование
			</a>
		</div>
		<div class="col_one_fourth catalog-promo catalog-promo-6">
			<a href="/catalog/viewCategory/30/torgovoe-oborudovanie/">
				Торговое оборудование
			</a>
		</div>
		<div class="col_one_fourth col_last catalog-promo catalog-promo-7">
			<a href="/catalog/viewCategory/31/zapasnye-chasti-k-dorozhno-stroitelnoj-tehnike/">
				Запасные части к дорожно-строительной технике
			</a>
		</div>
	</div>

	<div class="container clearfix topmargin-lg">
		<div class="col_one_fourth">
			<div class="fancy-title">
				<h3>Кто такая НИКА?</h3>
			</div>
			<p>
				"НИКА" занимается снабжением Юга России продукцией производственно-технического назначения. Генеральным партнером компании является <a href="http://atesy.ru/" rel="nofollow" target="_blank">машиностроительное предприятие ATESY</a>.
			</p>
			<div class="thumbnail ">
				<a href="http://atesy.ru/" rel="nofollow" target="_blank"><img src="/images/atesy.jpg" class="allmargin-sm" width="180" /></a>
			</div>
		</div>
		<div class="col_one_fourth">
			<div class="fancy-title">
				<h3>Новости</h3>
			</div>
			{section name="n" loop="$news" max="5"}
				<h4><a href="/news/{$news[n].content_id}/{$news[n].content_title|transliterate|escape|lower}">{$news[n].content_title}</a> <small>{$news[n].content_date|date_format}</small></h4>
			{/section}



		</div>
		<div class="col_one_fourth">
			<div class="fancy-title">
				<h3>Статьи</h3>
			</div>

			{section name="n" loop="$articles" max="5"}
				<h4><a href="/articles/{$articles[n].id}/{$articles[n].article_title|transliterate|escape|lower}">{$articles[n].article_title}</a> <small>{$articles[n].article_date|date_format}</small></h4>
			{/section}
		</div>
		<div class="col_one_fourth col_last">
			<div class="fancy-title">
				<h3>Курс валют</h3>
				<div class="" id="rates"></div>
			</div>
		</div>
	</div>
</section>


{literal}
	<script>
		var defaults = {
			delay: 3000,
			timer: false,
			shuffle: true,
			overlay: '/_libs/vegas/dist/overlays/10.png',
			transition: 'fade',
			transitionDuration: 1000
		};

		jQuery(function($){

			$.getJSON( "/my/getCurrency", function( json ) {
				var table = $(document.createElement('table')).addClass('table topmargin-sm');
				$.each(json, function (key, data) {
					data = parseFloat(data).toFixed(2);
					table.append("<tr><td><b>" + key + "</b></td><td class='text-right'>" + data + " руб.</td></tr>");
				});
				$('#rates').append(table);
			});

			$('.catalog-promo-1').vegas($.extend(defaults, {
				slides: [
					{ src: '/images/catalog-promos/holod.jpg' },
					{ src: '/images/catalog-promos/holod2.jpg' }
				]
			}));
			$('.catalog-promo-2').vegas($.extend(defaults, {
				delay: 4000,
				slides: [
					{ src: '/images/catalog-promos/food.jpg' },
					{ src: '/images/catalog-promos/food2.jpg' }
				]
			}));
			$('.catalog-promo-3').vegas($.extend(defaults, {
				delay: 5000,
				slides: [
					{ src: '/images/catalog-promos/ferma.jpg' },
					{ src: '/images/catalog-promos/ferma2.jpg' }
				]
			}));
			$('.catalog-promo-4').vegas($.extend(defaults, {
				delay: 3500,
				slides: [
					{ src: '/images/catalog-promos/alco.jpg' },
					{ src: '/images/catalog-promos/alco2.jpg' }
				]
			}));
			$('.catalog-promo-5').vegas($.extend(defaults, {
				delay: 4500,
				slides: [
					{ src: '/images/catalog-promos/upak.jpg' },
					{ src: '/images/catalog-promos/upak2.jpg' }
				]
			}));
			$('.catalog-promo-6').vegas($.extend(defaults, {
				delay: 5500,
				slides: [
					{ src: '/images/catalog-promos/trade.jpg' },
					{ src: '/images/catalog-promos/trade2.jpg' }
				]
			}));
			$('.catalog-promo-7').vegas($.extend(defaults, {
				delay: 6500,
				slides: [
					{ src: '/images/catalog-promos/road.jpg' },
					{ src: '/images/catalog-promos/road2.jpg' }
				]
			}));
		});

	</script>
{/literal}
