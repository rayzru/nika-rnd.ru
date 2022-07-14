{strip}{literal}{{/literal}
"results" : [{section name="id" loop="$results"}
	{if !$smarty.section.id.first},{/if}{literal}{{/literal}
	"id" 		: "{$results[id].item_id}",
	"text"		: "{$results[id].item_title|escape}"
	{literal}}{/literal}
{/section}]
{literal}}{/literal}
{/strip}