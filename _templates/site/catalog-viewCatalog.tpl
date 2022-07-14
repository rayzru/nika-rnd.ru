{include file="page-title.tpl" title=$page->title page_description="Полный перечень разделов и подразделов нашего каталога" no_breadcrumbs='true' }

<section id="content">
	<div class="content-wrap">
		<div class="container clearfix">
			<div class="row">
				{section name=i loop=$categories}
					<div class="col-md-4 topmargin-sm catalog-view">
						<h4 title="{$categories[i].title}"><a href="/catalog/viewCategory/{$categories[i].id}/{$categories[i].title|transliterate|lower}">{$categories[i].title}</a></h4>
						{section name=j loop=$categories[i].children}
							{assign var=count value=$categories[i].children[j].children|@count}
							{if $count == 0}
								<a href="/catalog/viewItems/{$categories[i].children[j].id}/{$categories[i].title|transliterate|lower}" title="{$categories[i].children[j].title}">{$categories[i].children[j].title}</a>
							{else}
								<a href="/catalog/viewCategory/{$categories[i].children[j].id}/{$categories[i].title|transliterate|lower}" title="{$categories[i].children[j].title}">{$categories[i].children[j].title}</a>
							{/if}
						{/section}
					</div>
				{/section}
			</div>
		</div>
	</div>
</section>

<script type="application/javascript">
	{literal}
	$(document).ready(function(){
		$('#content .row').masonry({
			columnWidth: 30,
			itemSelector: '.catalog-view'
		});
	});
	{/literal}
</script>