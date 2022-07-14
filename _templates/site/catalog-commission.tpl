<section id="page-title">
	<div class="container clearfix">
		<h1>Коммиссионный товар</h1>
	</div>
</section>

<div class="container">
	{foreach key=id from=$comm item=children}
		<div class="clearfix"></div>
		<div>
			<h3>{$children.title}</h3>

			{foreach name=i from=$children.children item=item}

			{if $smarty.foreach.i.index % 4 == 0}<div class="clearfix"></div>{/if}
			<div class="col-md-4 col-sm-6 col-xs-12 col-lg-3">
				<div
						class="categoryItemWrapper itemWrapper item{$item.item_id}"
						data-item="{$item.item_id}">

					<a href="/catalog/viewItem/{$item.item_id}/{$item.item_title|transliterate|escape|lower}"><div class="image" style="background-image: url(/images/catalog/250x250/{if $item.image_file != ''}{$item.image_file}{else}image_blank.jpg{/if})"></div></a>
					<h5><a href="/catalog/viewItem/{$item.item_id}/{$item.item_title|transliterate|escape|lower}">{$item.item_title}</a><div><small>{$item.item_key}</small></div></h5>
					{if $item.price > 0 && $item.availability != 2}<div class="itemPrice">{$item.price|number_format:2:".":""|replace:".00":''} <i class="fa fa-rub"></i></div>{/if}

					<div
							class="{if $item.availability == 0 || $item.availability == 2}itemNotAvail{else}itemAvail{/if}"
							title="{if $item.availability == 0}На данный момент данная позиция отсутствует на наших складах. Товар доступен для приобретения под заказ. Для более точных данных обратитесь к нашим менеджерам.{elseif $item.availability == 1}Товар имеется в наличии на наших складах.{elseif $item.availability == 2}Товар временно отсутствует у производителя{/if}">
						{if $item.availability == 0}Под заказ{elseif $item.availability == 1}В наличии{elseif $item.availability == 2}Временно отсутствует{/if}
					</div>

					<div class="itemControls">
						<button class="btn btn-success pull-right btn-xs add2CartButton add2CartButton{$item.item_id}"  data-loading-text="<i class='fa fa-spinner fa-spin fa-large'></i> Добавление..." {if ($user->logged)}onclick="add2cart({$item.item_id});"{else} data-toggle="modal" data-target="#authModal"{/if}>В корзину</button>
					</div>

					{if !empty($item.features)}
						<div class="itemFeatures">
							<table class="smallTableFeatures">
								{section name=f loop="`$item.features`"}
									<tr>
										<td>{$item.features[f].feature_title}</td>
										<td>{$item.features[f].feature_value} {$item.features[f].feature_unit}</td>
									</tr>
								{/section}
							</table>
						</div>
					{/if}

				</div>
			</div>
			{/foreach}
		</div>
	{/foreach}
</div>