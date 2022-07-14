{assign var="f" value="`$category_features`"}
{literal}{{/literal}
	"features" : [{section name="id" loop="$f"}
		{if !$smarty.section.id.first},{/if}{literal}{{/literal}
			"id"            : "{$f[id].id}",
			"feature_id"    : "{$f[id].id}",
			"feature_title" : "{$f[id].feature_title}",
			"feature_unit"  : "{$f[id].feature_unit}",
			"cid"           : "{$f[id].category_id}"
		{literal}}{/literal}
			{/section}]
{literal}}{/literal}
