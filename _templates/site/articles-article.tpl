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
		<li><a href="/info/articles/">информация</a></li>
		<li><a href="/info/articles/">статьи</a></li>
		<li>{$article.article_title}</li>
	</ul>
</div>

<div class="clr"></div>

<div  class="ma w960" >
	<div id="content_right_column">
		<div class="p20">
			Полезная информация:
			{include file="_right_column.tpl"}
		</div>
	</div>
	<div id="content_left_column" class="p20">
		<h1>{$article.article_title}</h1>
		{$article.article_text}
	</div>
</div>

<div class="clr p20"></div>

{include file="footer.tpl"}
