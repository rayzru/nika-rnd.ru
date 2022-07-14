{include file="page-title.tpl" title="Контакты" no_breadcrumbs=true page_description="Свяжитесь с нами любым, удобным для Вас способом"}

<!-- Content
============================================= -->
<section id="content">

	<div class="content-wrap">

		<div class="container clearfix">


			<!-- Contact Info
				============================================= -->
			<div class="row clear-bottommargin topmargin-sm">


				<div class="col-md-3 col-sm-6 bottommargin clearfix">
					<div class="feature-box fbox-center fbox-bg fbox-plain">
						<div class="fbox-icon">
							<a href="#"><i class="icon-map-marker2"></i></a>
						</div>
						<h3>Центральный офис <span class="subtitle">Ростов-на-Дону,<br/>ул. B. Черевичкина, 87</span></h3>
					</div>
				</div>

				<div class="col-md-3 col-sm-6 bottommargin clearfix">
					<div class="feature-box fbox-center fbox-bg fbox-plain">
						<div class="fbox-icon">
							<a href="#"><i class="icon-phone3"></i></a>
						</div>
						<h3>Звоните <span class="subtitle">{$contactPhone}<br/>{$contactPhone2}</span></h3>
					</div>
				</div>

				<div class="col-md-3 col-sm-6 bottommargin clearfix">
					<div class="feature-box fbox-center fbox-bg fbox-plain">
						<div class="fbox-icon">
							<a href="#"><i class="icon-printer"></i></a>
						</div>
						<h3>FAX <span class="subtitle">+7 (863) 291-45-96<br/>+7 (863) 291-45-97</span></h3>
					</div>
				</div>

				<div class="col-md-3 col-sm-6 bottommargin clearfix">
					<div class="feature-box fbox-center fbox-bg fbox-plain">
						<div class="fbox-icon">
							<a href="#"><i class="icon-mail"></i></a>
						</div>
						<h3>E-MAIL <span class="subtitle"><a href="mailto:info@nika-rnd.ru">info@nika-rnd.ru</a><br/><br/></span></h3>
					</div>
				</div>

			</div><!-- Contact Info End -->

			<div class="clear topmargin-sm"></div>

			<!-- Contact Form
			============================================= -->
			<div class="col_half">

				<div class="fancy-title ">
					<h3>Напишите нам</h3>
				</div>

				<div id="contact-form-result" data-notify-type="success" data-notify-msg="<i class=icon-ok-sign></i> Сообщение отправлено!"></div>

				<form class="nobottommargin" id="template-contactform" name="template-contactform" action="/contacts/feedback" method="post">

					<div class="form-process"></div>

					<div class="col_one_third">
						<label for="template-contactform-name">Имя <small>*</small></label>
						<input type="text" id="template-contactform-name" name="template-contactform-name" value="" class="sm-form-control required" />
					</div>

					<div class="col_one_third">
						<label for="template-contactform-email">Email <small>*</small></label>
						<input type="email" id="template-contactform-email" name="template-contactform-email" value="" class="required email sm-form-control" />
					</div>

					<div class="col_one_third col_last">
						<label for="template-contactform-phone">Телефон</label>
						<input type="text" id="template-contactform-phone" name="template-contactform-phone" value="" class="sm-form-control" />
					</div>

					<div class="clear"></div>

					<div class="col_full">
						<label for="template-contactform-message">Сообщение <small>*</small></label>
						<textarea class="required sm-form-control" id="template-contactform-message" name="template-contactform-message" rows="6" cols="30"></textarea>
					</div>

					<div class="col_full hidden">
						<input type="text" id="template-contactform-botcheck" name="template-contactform-botcheck" value="" class="sm-form-control" />
					</div>

					<div class="col_full">
						<button name="submit" type="submit" id="submit-button" tabindex="5" value="Отправить" class="button button-3d nomargin">Отправить</button>
					</div>

				</form>

				<script type="text/javascript">
					{literal}
					$("#template-contactform").validate({
							submitHandler: function(form) {
								$('.form-process').fadeIn();
								$(form).ajaxSubmit({
									target: '#contact-form-result',
									success: function() {
										$('.form-process').fadeOut();
										$('#template-contactform').find('.sm-form-control').val('');
										$('#contact-form-result').attr('data-notify-msg', $('#contact-form-result').html()).html('');
										SEMICOLON.widget.notifications($('#contact-form-result'));
									}
								});
							}
					});
					{/literal}
				</script>
			</div><!-- Contact Form End -->

			<!-- Google Map
			============================================= -->
			<div class="col_half col_last">

				<section id="google-map" class="gmap" style="height: 410px;"></section>

				<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
				<script type="text/javascript" src="/theme/js/jquery.gmap.js"></script>

				<script type="text/javascript">
					{literal}
					jQuery('#google-map').gMap({
						address: 'Россия, Ростов-на-Дону, ул. Bити Черевичкина, 87',
						maptype: 'ROADMAP',
						zoom: 17,
						markers: [{
							address: "Россия, Ростов-на-Дону, ул. Bити Черевичкина, 87",
							html: '<div style="width: 300px;"><h4 style="margin-bottom: 8px;"><span>НИКА</span></h4><p class="nobottommargin">Поставляем промышленное оборудование.</p></div>',
							icon: {
								image: "/theme/images/icons/map-icon-red.png",
								iconsize: [32, 39],
								iconanchor: [32,39]
							}
						}],
						doubleclickzoom: false,
						controls: {
							panControl: true,
							zoomControl: true,
							mapTypeControl: true,
							scaleControl: false,
							streetViewControl: false,
							overviewMapControl: false
						}

					});
					{/literal}
				</script>

			</div><!-- Google Map End -->

			<div class="clear"></div>
		</div>
	</div>
</section><!-- #content end -->


<script type="text/javascript">
	{literal}
	$(function() {
		$('form#feedback').submit(function(event){
			var form = this;
			$('.alert', form).remove();
			event.preventDefault();
			$('#sendButton').button('loading');
			var data = $(form).serialize()
			$.post(form.action, data, function(response) {
				console.log(response);
				if (response != 'ok') {
					$(form).prepend(response);
				} else {
					showNotify('<h4>Сообщение отправлено</h4>Ваще сообщение успешно отправлено<br/>' +
							'и будет вскоре прочитано нашими специалистами.<br/>' +
							'Ждите скорейшего ответа.<br/>' +
							'Большое спасибо!');

					document.getElementById("feedback").reset();
				}
				$('#sendButton').button('reset');
			});
		});

	});

	{/literal}
</script>
