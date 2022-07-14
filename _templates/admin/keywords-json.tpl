{literal}{{/literal}
	"query": "{$query}",
	"keywords": [
	{section name=id loop="$keywords"}
		{if !$smarty.section.id.first},{/if} {ldelim}
		"id": "{$keywords[id].id}",
		"text": "{$keywords[id].keyword}" {rdelim}
	{/section}
	]
{literal}}{/literal}