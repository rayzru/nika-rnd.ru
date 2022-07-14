{include file="page-title.tpl" title="Заказ оформлен" }

<section id="content" class="content-wrap">
	<div class="container">

		<div class="col_one_third">
			<h4>Заказ №{$orderNumber}</h4>
			<p>Спасибо, Ваш заказ принят! На указанный Вами <nobr>e-mail</nobr> будет автоматически выслано письмо с данными Вашего заказа. Также на сайте Вы можете отслеживать статус Вашего заказа и просматривать историю прошлых заказов.</p>
			<p>В случае возникловения вопросов вы всегда можете обратится к нашим менеджерам по телефонам указанным в разделе <a href="/contacts/">Контакты</a>.</p>
			<p>После оформления заказа, наш менеджер свяжется с Вами по указанному Вами телефону.</p>

		</div>
		<div class="col_one_third">
			<h4>Что делать дальше?</h4>
			<p>Возможно, Вы не остановитесь за достигнутом и сделаете еще один заказ на сопутствующее оборудование и материалы в нашем <a href="/catalog/">обширном каталоге</a></p>
			<p>Вы всегда можете заглянуть в раздел <a href="/my/orders/">ваших заказов</a> что бы посмотреть на их готоность и содержимое.</p>
		</div>
		<div class="col_one_third col_last">
			<h4>На связи</h4>
			<p>Наши менеджеры на столько благодарны, что даже сейчас улыбаются вам.</p>
			<p>Возможно вы хотите поговорить о вашем заказе. Не стесняйтесь, мы уже ждем вашего звонка, не снимая руку с телефона.</p>
			<h2>{$contactPhone}</h2>
		</div>

		<div class="clear"></div>

		<div class="col_one_third">
			<a href="/my/orders/{$orderNumber}" class="button button-3d">Посмотреть заказ №{$orderNumber}</a>
		</div>
		<div class="col_one_third">
			<a href="/my/orders/" class="button button-border">Посмотреть все заказы</a>

		</div>
		<div class="col_one_third col_last">
			<a href="/contacts/" class="button button-border">Выйти на связь</a>
		</div>

	</div>
</section>