[{section name="id" loop="$nodes"}
		{literal}{{/literal}
		"key"		: "{$nodes[id].category_id}",
		"folder"	: {if $nodes[id].is_leaf == 'true'}false{else}true{/if},
		"lazy"		: {if $nodes[id].is_leaf == 'true'}false{else}true{/if},
		"title"		: "{$nodes[id].category_title|escape:"html"}",
		"tooltip"	: "{$nodes[id].category_title|escape:"html"}"
	{literal}}{/literal}{if !$smarty.section.id.last},{/if}
{/section}]