{strip}
{literal}{{/literal}
	"category_id": "{$category_id}",
	"items": [
	{section name=id loop="$items"}
		{if !$smarty.section.id.first},{/if}
		{literal}{{/literal}
		"item_id" :  "{$items[id].item_id}",
		"item_title" : "{$items[id].item_title|escape}"
		{literal}}{/literal}
	{/section}
	]
{literal}}{/literal}
{/strip}