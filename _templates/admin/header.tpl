<!DOCTYPE html>
<html>
<head>
	<title>Панель управления / {$page_title}</title>		
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

	<!-- FAVICON -->
	<link rel="shortcut icon" href="/images/favicon/favicon.ico" type="image/x-icon">
	<link rel="icon" href="/images/favicon/favicon.ico" type="image/x-icon">
	<link rel="icon" href="/images/favicon/favicon.ico" type="image/vnd.microsoft.icon" />

	{foreach from=$page->styles key=k item=style}
		<link rel=stylesheet type="text/css" href="{$style.url}" />
	{/foreach}

	{foreach from=$page->scripts key=k item=script}
		<script type="{$script.type}" src="{$script.url}"></script>
	{/foreach}

</head>
<body>
{if isset($admin) && $admin->logged}{include file="menu.tpl"}{/if}
<div class="container">
