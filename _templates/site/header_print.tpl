<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
	{strip}<title>{$page_title}
	{if isset($all_categories)}
		{section name="id" loop="$all_categories" step="-1"}
			{if !$smarty.section.id.first}
				&nbsp;-&nbsp;{$all_categories[id].category_title}
			{elseif (isset($item))}
				&nbsp;-&nbsp;{$all_categories[id].category_title}
			{/if}
		{/section}
		&nbsp;-&nbsp;Каталог
	{/if}
	</title>{/strip}
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta http-equiv="CACHE-CONTROL" content="NO-CACHE" />
	<meta http-equiv="PRAGMA" content="NO-CACHE" />

	<link rel="stylesheet" type="text/css" href="/css/style.css" />
    <link rel="stylesheet" type="text/css" media="print" href="/css/print.css" />
    <link rel="icon" type="image/vnd.microsoft.icon" href="/favicon.ico" />
    <link rel="SHORTCUT ICON" href="/favicon.ico" />

	<meta name="description" content="{strip}{$page_description|strip_tags|replace:'"':'&quot;'}{/strip}" />
	<meta name="keywords" content="{$page_keywords|escape}, {if isset($all_categories)}{section name="id" loop="$all_categories"}{if !$smarty.section.id.first}, {$all_categories[id].category_title}{elseif (isset($item))}, {$all_categories[id].category_title}{/if}{/section}, Каталог оборудования{/if}" />

{literal}
<script type="text/javascript">

  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-3557573-26']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();

</script>
{/literal}
</head>
<body class="{$bodyClass}">
