{assign var="f" value="`$item.features`"}
{assign var="i" value="`$item.images`"}
{literal}{{/literal}
	"item_id" : "{$item.item_id}",
	"item_title" : "{$item.item_title|escape}",
	"item_title_alternative" : "{$item.item_title_alternative|escape}",
	"item_key" : "{$item.item_key|escape}",
	"item_price" : "{$item.price}",
	"item_unit" : "{$item.item_unit|escape}",
	"item_availability" : {$item.availability},
	"item_active" : {$item.active},
	"item_description_short" : "{$item.item_description_short}",
	"item_description" : "{$item.item_description}",
	"item_new" : {$item.item_new},
	"show_image" : "{$item.show_image}",
	"features" : [{section name="id" loop="$f"}
		{if !$smarty.section.id.first},{/if}{literal}{{/literal}
			"feature_id"    : "{$f[id].feature_id}",
			"feature_title" : "{$f[id].feature_title}",
			"feature_value" : "{$f[id].feature_value}",
			"feature_unit"  : "{$f[id].feature_unit}",
			"item_id"       : "{$item.item_id}"
		{literal}}{/literal}
			{/section}],
	"images" : [{section name="id" loop="$i"}
		{if !$smarty.section.id.first},{/if}{literal}{{/literal}
			"image_id"      : "{$i[id].image_id}",
			"image_file"    : "{$i[id].image_file}",
			"default_image" : "{$i[id].default_image}",
			"item_id"       : "{$item.item_id}"
		{literal}}{/literal}
			{/section}]
{literal}}{/literal}
