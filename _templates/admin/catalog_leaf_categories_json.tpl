{assign var="f" value="`$categories`"}
{literal}{{/literal}
	"categories" : [{section name="id" loop="$f"}
		{if !$smarty.section.id.first},{/if}{literal}{{/literal}
			"id" 		: "{$f[id].category_id}",
			"text"		: "{$f[id].category_title}"
		{literal}}{/literal}
			{/section}]
{literal}}{/literal}
