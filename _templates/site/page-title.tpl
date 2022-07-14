<section id="page-title" class="bottommargin-sm">
	<div class="container clearfix">
		<h1>{$title}</h1>
		{if isset($page_description)}<span>{$page_description}</span>{/if}
		{if !isset($no_breadcrumbs)}
		<ol class="breadcrumb">
			{if isset($path)}
				<li><a href="/catalog/">Каталог</a></li>
				{section name="i" loop="$path"}
					{if  $smarty.section.i.last && !isset($item)}
						<li>{$path[i].category_title}</li>
					{elseif $smarty.section.i.last && isset($item)}
						<li><a title="{$path[i].category_title|escape}" href="/catalog/viewItems/{$path[i].category_id}/{$path[i].category_title|transliterate|escape|lower}">{$path[i].category_title}</a></li>
					{else}
						<li><a title="{$path[i].category_title|escape}" href="/catalog/viewCategory/{$path[i].category_id}/{$path[i].category_title|transliterate|escape|lower}">{$path[i].category_title}</a></li>
					{/if}
				{/section}
			{else}
				<li><a href="/">Главная</a></li>
				{section name="j" loop="$breadcrumbs"}
					{if  $smarty.section.j.last}
						<li>{$breadcrumbs[j].title}</li>
					{else}
						<li><a class="bstooltip" data-placement="bottom" data-toggle="tooltip" title="{$breadcrumbs[j].title}" href="{$breadcrumbs[j].path}">{$breadcrumbs[j].title}</a></li>
					{/if}
				{/section}
			{/if}
		</ol>
		{/if}
	</div>
</section>