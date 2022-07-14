{literal}{{/literal}
	"id" : "{$content.content_id}",
	"label" : "{$content.content_label|escape}",
	"title" : "{$content.content_title|escape}",
	"text" : "{strip}{$content.content_text|replace:'"':'&quot;'}{/strip}"
{literal}}{/literal}
