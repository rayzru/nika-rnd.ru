{include file="page-title.tpl" title=$item.item_title }

<section id="content" class="content-wrap">
	<div class="container">
		<div class="single-product">

			<div class="product">
				{if count($item.images)}
				<div class="col_two_fifth">

					<!-- Product Single - Gallery
					============================================= -->
					<div class="product-image">
						<div class="fslider" data-pagi="false" data-arrows="false" data-thumbs="true">
							<div class="flexslider">
								<div class="slider-wrap" data-lightbox="gallery">
									{section name='i' loop="`$item.images`"}
										<div class="slide" data-thumb="/images/catalog/100x100/{$item.images[i].image_file}">
											<a href="/images/catalog/{$item.images[i].image_file}" title="{strip}{$item.item_title|escape}{/strip}" data-lightbox="gallery-item">
												<img src="/images/catalog/300x300/{$item.images[i].image_file}" alt="{strip}{$item.item_title|escape}{/strip}">
											</a>
										</div>
									{/section}
								</div>
							</div>
						</div>

					</div><!-- Product Single - Gallery End -->

				</div>
				{/if}
				<div class="{if count($item.images)}col_three_fifth{else}col_full{/if} product-desc col_last">

					<div class="fright text-right">
						<div class="quantity clearfix">
							<input type="button" value="-" class="minus" rel='quantity'>
							<input type="text" step="1" min="1" name="quantity"  value="1" title="Количество" class="qty" size="4">
							<input type="button" value="+" class="plus" rel='quantity'>
						</div>
						<button class="add-to-cart add2cart button nomargin add2CartButton add2CartButton{$item.item_id}" data-loading-text="<i class='fa fa-spinner fa-spin fa-large'></i> Добавление..."
								{if ($user->logged)}onclick="add2cart({$item.item_id}, $('.qty').val());"{else} data-toggle="modal" data-target="#authModal"{/if}>
							Добавить в корзину
						</button>
						{if $inCart}<br/><button class="dd-to-cart topmargin-sm norightmargin add2cart button button-mini button-white button-light  add2CartButton removeCartButton{$item.item_id}"  data-loading-text="<i class='fa fa-spinner fa-spin fa-large'></i> Удаление..." onclick="removecart({$item.item_id});">Товар в корзине. Убрать?</button>{/if}

					</div>
					<!-- Product Single - Price
					============================================= -->
					<div class="product-price">{if $item.price > 0 && $item.availability != 2}<div class="itemPrice">{$item.price|number_format:2:".":""|replace:".00":''} руб.</div>{/if}</div><!-- Product Single - Price End -->

					<!-- Product Single - Rating
					============================================= -->

					{if isset($rating.value)}
					<div class="product-rating">
						{section name=i start=1 max=$rating.value}
							<i class="icon-star3"></i>
						{/section}
						{if ( 0 <= ($rating.value - $section.section.i.iteration) && ($rating.value - $section.section.i.iteration) < 0.3) }
							<i class="icon-star-empty"></i>
						{elseif ( 0.3 <= ($rating.value - $section.section.i.iteration) && ($rating.value - $section.section.i.iteration) < 0.8)}
							<i class="icon-star-half-full"></i>
						{else}
							<i class="icon-star3"></i>
						{/if}

						{*for $j=0; $j<5-$i; $j++}<i class="icon-star-empty"></i>{/for*}

					</div><!-- Product Single - Rating End -->
					{/if}


					<div class="clear"></div>
					<div class="line"></div>

					{if $item.price_warn == 1 && $item.price > 0}
						<div class="alert alert-dismissable alert-warning" style="margin: 1em 0;">
							<h4><i class="fa fa-warning"></i> Цена для розничной продажи</h4>
							Стоимость товара для юридических лиц Вы можете,<br/>проконсультировавшись с нашими менеджерами по телефонам<br/>+7 (863) 251-63-54, 291-45-96
						</div>
					{/if}

					{if $item.commission == 1}
						<div class="style-msg2 alertmsg">
							<div class="sb-msg">
								<i class="icon-asterisk"></i> Данный товар является комиссионным. На него распространяется выгодная цена
							</div>
						</div>
					{/if}


					<!-- Product Single - Meta
					============================================= -->
					<div class="panel panel-default product-meta">
						<div class="panel-body">
							<span itemprop="productID" class="sku_wrapper">Артикул: <b class="sku">{$item.item_key}</b></span>
							<span itemprop="availability" class="">Наличие: <span class="avail-badge2 {if $items[i].availability == 0}order{elseif $items[i].availability == 1}ok{else}none{/if}">{if $item.availability == 0}Под заказ.
									{if $item.arrives_in == 2}Срок выполнения заказа 1-2 дня.{elseif $item.arrives_in == 5}Срок выполнения заказа 5 дней.{elseif $item.arrives_in == 7}Срок выполнения заказа - неделя.{elseif $item.arrives_in == 14}Срок выполнения заказа 2 недели.{elseif $item.arrives_in == 30}Срок выполнения заказа 1 месяц.{elseif $item.arrives_in == 60}Срок выполнения заказа 2 месяца.{else}Обратитесь к нашим менеджерам для уточнения срока доставки заказа.{/if}
								{elseif $item.availability == 1}Есть на складе{elseif $item.availability == 2}Временно отсутствует{/if}</span><span>
						</div>
					</div><!-- Product Single - Meta End -->

					<!-- Product Single - Share
					============================================= -->

				</div><!-- Product Single - Share End -->

			</div>

			<div class="col_full nobottommargin">

				<div class="tabs clearfix nobottommargin" id="tab-1">

					<ul class="tab-nav clearfix">
						<li><a href="#description"><i class="icon-align-justify2"></i><span class="hidden-xs"> Описание</span></a></li>
						<li><a href="#specs"><i class="icon-info-sign"></i><span class="hidden-xs"> Характеристики</span></a></li>
						<li><a href="#reviews"><i class="icon-star3"></i><span class="hidden-xs"> Отзывы</span></a></li>
						<li><a href="#qa"><i class="icon-user-md"></i><span class="hidden-xs"> Консультации</span></a></li>
					</ul>

					<div class="tab-container">
						<div class="tab-content clearfix" id="description">
							<p>{$item.item_description|stripslashes}</p>
						</div>
						<div class="tab-content clearfix" id="specs">
							<table class="table table-striped table-bordered">
								<tbody>
								{section name="id" loop="`$item.features`"}
									<tr>
										<td>{$item.features[id].title}</td>
										<td>{$item.features[id].feature_value} {if $item.features[id].unit != ''} {$item.features[id].unit}{/if}</td>
									</tr>
								{/section}
								</tbody>
							</table>

						</div>
						<div class="tab-content clearfix" id="reviews">

							<div id="reviews" class="clearfix">

								<ol class="commentlist clearfix">


									{section name="i" loop="$reviews"}
										<li class="comment even thread-even depth-1" id="li-comment-1">
											<div id="comment-1" class="comment-wrap clearfix nopadding">
												<div class="comment-content clearfix">
													<div class="comment-author">{$reviews[i].name} {if $reviews[i].user_id == $user->id}<abbr class="badge">Ваш отзыв</abbr>{/if}<span><a href="#" title="">{$reviews[i].rate_date|date_format:"%d %m %Y"}</a></span></div>
													<p>{$reviews[i].review}</p>
													<div class="review-comment-ratings">
														{section name=j loop=6 start=1 max=6}
															{assign var="rating" value=`$reviews[i].rating`}
															{assign var="index" value=`$smarty.section.j.index`}
															<i class="icon-star{if $index > $rating }-empty{else}3{/if}"></i>
														{/section}
													</div>
												</div>

												<div class="clear"></div>

											</div>
										</li>
										{sectionelse}
										<li>
											<p class="text-muted">Еще никто не оставлял отзывов. Станьте первым, напишите свой отзыв.</p>
										</li>
									{/section}
								</ol>

								{if $user->logged}
									{if !$ranked}
										<button data-toggle="modal" data-target="#reviewFormModal" class="formReviewToggler button button-mini button-3d bottommargin-sm" onclick="$('.formReview, .formReviewToggler').toggle();">Оставить отзыв</button>

										<form method="post" action="/catalog/addReview/{$item.item_id}" class="formReview">
											<div class="form-group">
												<div class="pull-right">
													{if isset($rating.value)}
														<div class="avgrating userRating"></div>
													{literal}
														<script type="text/javascript">
															$(function(){
																$('.avgrating').raty({
																	starType: 'i',
																	score: {/literal}{$rating.value}{literal},
																	hints: ['Очень плохо!', 'Плохо', 'Нормально', 'Хорошо', 'Отлично!'],
																	halfShow: true,
																	readOnly: true
																});
															});
														</script>
													{/literal}
													{/if}
												</div>
												<script type="text/javascript">
													{literal}
													$(function(){
														$('.userRating').raty({ starType: 'i',  cancel: true, hints: ['Очень плохо!', 'Плохо', 'Нормально', 'Хорошо', 'Отлично!']});

														$('.formReview').submit(function(e){
															e.preventDefault();
															var formData = $(this).serializeArray();
															if (!parseInt(formData[0].value)) {
																$('.formReview').before("<div class='alert alert-danger alert-dismissable'><button type='button' class='close' data-dismiss='alert'><span aria-hidden='true'>&times;</span><span class='sr-only'>Закрыть</span></button>" +
																		"Поставьте оценку товару по пятибальной шкале. 1 - отвратительно, 2 - плохо, 3 - нейтрально, 4 - хорошо, 5 - отлично.</div>");
																return false;
															}
															if (formData[1].value == '' || formData[1].value.length < 20) {
																$('.formReview').before("<div class='alert alert-danger alert-dismissable'><button type='button' class='close' data-dismiss='alert'><span aria-hidden='true'>&times;</span><span class='sr-only'>Закрыть</span></button>" +
																		"Опишите ваше мнение, лучшие и худшие стороны, а так же комментарии. Отзыв должет содержать не менее 20 символов.</div>");
																return false;
															}
															$.post($(this).attr('action'), formData, function(response){
																if (response == 'ok') {
																	$('.formReview').before("<div class='alert alert-success'><h4>Большое спасибо!</h4>Ваш отзыв добавлен. Ваше мнение очень важно для нас. В скором времени он появится на сайте, как только наши менеджеры проверят его.</div>").animate({height: 0},400,function(){
																		$(this).remove();
																	});
																} else {
																	$('.formReview').append('<div class="alert alert-danger">Ошибка добавления отзыва. Попробуйте еще раз.</div>')
																}
															});
														});

														$('#reviewText').keyup(function () {
															$('.reviewSymbolCount').text($(this).val().length)
														});

													});
													{/literal}
												</script>
											</div>
											<div class="form-group">
												<div class="userRating pull-right"></div> <label>Отзыв</label>
												<textarea name="review" class="form-control" rows="5" id="reviewText"></textarea>
											</div>
											<div class="form-group">
												<div class="pull-right col-md-6">
													<span class="text-muted">Требуется не менее 20 символов. Вы набрали <span class="reviewSymbolCount">0</span>.</span>
												</div>
												<input type="submit" class="btn btn-default" value="Отправить">
											</div>
										</form>
									{else}
										<p class="text-muted">Вы уже оставили отзыв.</p>
									{/if}
								{else}
									<a href="#" class="toggleAuth button button-3d nomargin fright" data-toggle="modal" data-target="#authModal">Войти, что бы оставить свой отзыв</a>
									<p class="text-muted">Только авторизированные пользователи могут оставлять отзывы.</p>
								{/if}


							</div>

						</div>
						<div class="tab-content clearfix" id="qa">
							<div id="faqs" class="faqs commentlist clearfix">
								{section name="id" loop="$qa"}

									<div class="toggle faq faq-marketplace faq-authors">
										<div class="togglet">
											<div class="text-muted fright"><time datetime="{$qa[id].published_date}">{$qa[id].published_date|date_format}</time></div>
											<i class="toggle-closed icon-question-sign"></i><i class="toggle-open icon-question-sign"></i> {$qa[id].question}
										</div>
										<div class="togglec">
											{$qa[id].answer}
										</div>
									</div>
								{sectionelse}
									<div class="text-muted">Консультации отсутствуют</div>
								{/section}
							</div>


							<form method="post" action="/qa/add/{$item.item_id}" id="formQA">

								<a href="#" data-toggle="modal" data-target="#ask" class="button button-3d bottommargin-sm button-mini">Задать вопрос специалисту</a>

								<div class="modal fade" id="ask" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
									<div class="modal-dialog">
										<div class="modal-content">
											<div class="modal-header">
												<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
												<h4 class="modal-title" id="myModalLabel">Задать вопрос специалистам</h4>
											</div>
											<div class="modal-body">
												<p>Обратите внимание, возможно ответ на ваш вопрос уже опубликован во вкладке "Консультации" данного товара. Имейте ввиду, отправляя вопрос вы адресуете его нашим специалистам к товару <span class="label label-default">{$item.item_title}</span></p>
												{if !$user->logged}
													<div class="form-group">
														<label>Ваше имя</label>
														<input type="text" name="name" value="" class="form-control">
													</div>
													<div class="form-group">
														<label>Email</label>
														<input type="email" name="email" value=""  class="form-control" required="required">
													</div>
													<div class="form-group">
														<label>Телефон для связи</label>
														<input type="text" name="phone" value=""  class="form-control">
													</div>
												{else}
													<div class="form-group">
														<label>Вы зашли как</label>
														<div class="form-control-static">{$user->account->login}</div>
													</div>
												{/if}

												<div class="form-group">
													<label>Ваш вопрос</label>
													<textarea name="question" class="form-control" rows="5"></textarea>
												</div>

												<div class="form-group">
													<label>Решите, сколько будет {$captcha}</label>
													<input type="text" name="captcha" class="form-control">
												</div>

												<button type="button" class="btn btn-default pull-right" data-dismiss="modal">Закрыть</button>
												<button type="submit" class="btn btn-success" id="submitQA">Отправить вопрос</button>
											</div>
										</div>
									</div>
								</div>
							</form>


						</div>
					</div>

				</div>

			</div>

		</div>
	</div>
</section>


{literal}
<script type="application/ecmascript">
	$(function(){
		$('#formQA').submit(function(e){
			e.preventDefault();
			var form = this;
			$.post(form.action, $(form).serialize(), function(response){
				if (response == 'ok') {
					form.question.value = '';
					$('#ask').modal('toggle');
					showNotify('<h4>Ваш вопрос был отправлен</h4>Ожидайте ответа от наших специалистов в указанной Вами электронной почте<br/>или на странице товара в качестве консультации.');
				} else {
					if (response == 'error') showNotify('<h4>Ошибка добавления вопроса</h4>Попробуйте обратится позже.');
					if (response == 'captcha error') showNotify('<h4>Вы ввели неправильное решение</h4>Для защиты от спама, мы вынуждены проверять вас на человечность, простите. Повторите, пожалуйста ввод вашего вопроса и решите небольшую задачку в конце нашей формы.');
					//$('#ask').modal('close');
				}
			});
		});
	});

</script>
{/literal}

{literal}
	<script type="text/javascript">
		$(function(){
			var hash = window.location.hash;
			hash && $('ul.nav a[href="' + hash + '"]').tab('show');

			$('.nav-tabs a').click(function (e) {
				e.preventDefault();
				$(this).tab('show');
				var scrollmem = $('body').scrollTop();
				window.location.hash = this.hash;
				$('html,body').scrollTop(scrollmem);
			});
		});
	</script>
{/literal}