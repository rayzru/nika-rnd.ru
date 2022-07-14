{include file="page-title.tpl" title=$page->title }
<div class="container clearfix">
	<table class="table" style="margin-top: 20px;font-size: smaller;">
		<thead>
		<tr>
			<th></th>
			{section name="i" loop="$items"}
			<th>
				<div class="media">
					<a class="pull-left" href="#">
						<img class="media-object" src="/images/catalog/50x50/{if $items[i].image_file != ''}{$items[i].image_file}{else}image_blank.jpg{/if}" alt="">
					</a>
					<div class="media-body">
						<h4 class="media-heading"><a href="/catalog/viewItem/{$items[i].item_id}">{$items[i].item_title}</a><div><small>{$items[i].item_key}</small></h4>
						{if $items[i].price > 0}<div class="itemPrice">{$items[i].price|number_format:2:".":""|replace:".00":''} <i class="fa fa-rub"></i></div>{/if}
					</div>
				</div>
			</th>
			{/section}
		</tr>
		</thead>
		<tbody>
		{foreach from="`$features.list`" item="feature_id"}
			<tr>
				<td><b>{$featuresData[$feature_id].feature_title}</b></td>
				{foreach from="`$features.items`" item="fi" key="item_id"}
					{if $fi.$feature_id != ''}
						<td>{$fi.$feature_id} {$featuresData[$feature_id].feature_unit}</td>
					{else}
						<td class="text-muted">-</td>
					{/if}
				{/foreach}
			</tr>
		{/foreach}
		</tbody>
	</table>
</div>