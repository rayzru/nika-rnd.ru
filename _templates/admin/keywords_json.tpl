{literal}{{/literal}
	"query": "{$query}",
	"keywords": [
	{section name=id loop="$keywords"}
		{if !$smarty.section.id.first},{/if}
		"{$keywords[id].keyword}"{/section}
	]
{literal}}{/literal}