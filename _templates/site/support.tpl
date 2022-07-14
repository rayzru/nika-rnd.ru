{* 
  Template {index} 
  Created by {RayZ}
  Date {11.10.2010}
*}

{include file="header.tpl"}

<div class="clr"></div>

<div class="ma w960" id="pathContainer">
	<h1>{$page_title}</h1>
	<ul id="path">
		<li><a href="/">Главная</a></li>
		<li>Поддержка</li>
	</ul>
</div>

<div class="clr"></div>

<div id="content">
	<div class="p10">
		{$content->content_text}
	</div>
</div>

<div class="clr p20"></div>

{include file="footer.tpl"}