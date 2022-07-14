<!DOCTYPE html>
<html dir="ltr" lang="ru-RU">
<head>
	{strip}<title>{$page->title}</title>{/strip}

	<meta http-equiv="content-type" content="text/html; charset=utf-8" />
	<meta name="author" content="RayZ.ru" />

	<meta name="description" content="{$page->description|strip|strip_tags|trim}" />
	<meta name="keywords" content="{foreach from=$page->keywords key=k item=kw}{if $k != 0},{/if}{$kw|strip|strip_tags}{/foreach}" />

	<link href="http://fonts.googleapis.com/css?family=Open+Sans:300,400,400italic,600,700,800|Roboto:300,400,500,600,700|Roboto+Slab:400italic&subset=latin,cyrillic" rel="stylesheet" type="text/css" />

	<link rel="stylesheet" href="/theme/css/bootstrap.css" type="text/css" />
	<link rel="stylesheet" href="/theme/style.css" type="text/css" />
	<link rel="stylesheet" href="/theme/css/dark.css" type="text/css" />
	<link rel="stylesheet" href="/theme/css/font-icons.css" type="text/css" />
	<link rel="stylesheet" href="/theme/css/animate.css" type="text/css" />
	<link rel="stylesheet" href="/theme/css/magnific-popup.css" type="text/css" />

	<link rel="stylesheet" href="/theme/css/responsive.css" type="text/css" />
	<meta name="viewport" content="width=device-width, initial-scale=1" />
	<!--[if lt IE 9]>
	<script src="http://css3-mediaqueries-js.googlecode.com/svn/trunk/css3-mediaqueries.js"></script>
	<![endif]-->

	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">


	<!-- FAVICON -->
	<link rel="shortcut icon" href="/images/favicon/favicon.ico" type="image/x-icon">
	<link rel="icon" href="/images/favicon/favicon.ico" type="image/x-icon">
	<link rel="icon" href="/images/favicon/favicon.ico" type="image/vnd.microsoft.icon" />

	<link rel="apple-touch-icon" sizes="57x57" href="/images/favicon/apple-icon-57x57.png">
	<link rel="apple-touch-icon" sizes="60x60" href="/images/favicon/apple-icon-60x60.png">
	<link rel="apple-touch-icon" sizes="72x72" href="/images/favicon/apple-icon-72x72.png">
	<link rel="apple-touch-icon" sizes="76x76" href="/images/favicon/apple-icon-76x76.png">
	<link rel="apple-touch-icon" sizes="114x114" href="/images/favicon/apple-icon-114x114.png">
	<link rel="apple-touch-icon" sizes="120x120" href="/images/favicon/apple-icon-120x120.png">
	<link rel="apple-touch-icon" sizes="144x144" href="/images/favicon/apple-icon-144x144.png">
	<link rel="apple-touch-icon" sizes="152x152" href="/images/favicon/apple-icon-152x152.png">
	<link rel="apple-touch-icon" sizes="180x180" href="/images/favicon/apple-icon-180x180.png">
	<link rel="icon" type="image/png" sizes="192x192"  href="/images/favicon/android-icon-192x192.png">
	<link rel="icon" type="image/png" sizes="32x32" href="/images/favicon/favicon-32x32.png">
	<link rel="icon" type="image/png" sizes="96x96" href="/images/favicon/favicon-96x96.png">
	<link rel="icon" type="image/png" sizes="16x16" href="/images/favicon/favicon-16x16.png">
	<link rel="manifest" href="/images/favicon/manifest.json">
	<meta name="msapplication-TileColor" content="#ffffff">
	<meta name="msapplication-TileImage" content="/images/favicon/ms-icon-144x144.png">

	<meta name="theme-color" content="#1F9BED">

	<script type="text/javascript" src="/theme/js/jquery.js"></script>
	<script type="text/javascript" src="/theme/js/plugins.js"></script>

	<!-- SLIDER REVOLUTION 4.x SCRIPTS  -->
	<script type="text/javascript" src="/theme/include/rs-plugin/js/jquery.themepunch.tools.min.js"></script>
	<script type="text/javascript" src="/theme/include/rs-plugin/js/jquery.themepunch.revolution.min.js"></script>
	<!-- SLIDER REVOLUTION 4.x CSS SETTINGS -->
	<link rel="stylesheet" type="text/css" href="/theme/include/rs-plugin/css/settings.css" media="screen" />


	{foreach from=$page->styles key=k item=style}<link rel="stylesheet" type="text/css" href="{$style.url}">{/foreach}

	{foreach from=$page->scripts key=k item=script}<script type="{$script.type}" src="{$script.url}"></script>{/foreach}

	{literal}<script type="text/javascript">
		(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
					(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
				m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
		})(window,document,'script','//www.google-analytics.com/analytics.js','ga');

		ga('create', 'UA-3557573-40', 'auto');
		ga('send', 'pageview');

	</script>{/literal}
</head>

<body  class="stretched">
	{include file="my-ajaxloginformWrapper.tpl"}
	<div id="wrapper" class="clearfix">

	{include file="navigation.tpl"}

