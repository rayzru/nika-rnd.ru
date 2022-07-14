[ "data" : {literal}{{/literal}{section name="id" loop="$nodes"}
	{literal}{{/literal}"attr" :
		{literal}{{/literal}
			"id" : "",
			"rel" : ""
		{literal}}{/literal},
	"data" : "{$nodes[id].category_title}",
	"state" : "closed"
	{literal}}{/literal}{if !$smarty.section.id.last},{/if}
{/section}
{literal}}{/literal}]