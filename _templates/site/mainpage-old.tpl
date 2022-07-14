{strip}

<div class="container">
	<div class="row">
		<div class="col-md-8">
			<div class="mainPageSearchbar">
				<form method="get" action="/catalog/search" id="search">
					<div class="input-group input-group-lg">
						<input type="text" class="form-control" placeholder="Search for...">
						  <span class="input-group-btn">
							<button class="btn btn-default" type="submit">Найти</button>
						  </span>
					</div><!-- /input-group -->
				</form>
			</div>
		</div>
		<div class="col-md-4">
			<div class="stats">
				{$totalItems} товаров
			</div>
		</div>
	</div>
</div>

<div class="">
	<div class="container">
		<div class="row">
			<div class="col-md-12 categoriesList">
				<ul class="mainCategory">
				{section name=i loop=$categories}
					<li class="col-md-2">
						<a title="{$categories[i].title}" href="/catalog/viewCategory/{$categories[i].id}/{$categories[i].title|transliterate|escape|lower}">
							<i class="icon-{$categories[i].id}"></i>
							{$categories[i].title}
						</a>
					</li>
				{/section}
				</ul>
			</div>
			<div class="col-md-12">
				<div class="text-center" style="font-size:11px;"><a href="#" class="categoriesToggle"><i class="fa fa-angle-down"></i> показать другие разделы каталога</a> <span class="text-muted">или показать</span> <a href="/catalog/">весь каталог</a></div>
			</div>
		</div>
		<div class="clearfix"  style="margin-bottom:20px;"></div>
	</div>
</div>
<div class="cloudsBg">
	<div class="container">
		<div class="row">
			<div class="col-md-4">
				<h2><a href="/news/">Новости</a></h2>
				{section name="n" loop="$news" max="5"}
					<h4><a href="/news/{$news[n].content_id}/{$news[n].content_title|transliterate|escape|lower}">{$news[n].content_title}</a> <small>{$news[n].content_date|date_format}</small></h4>
				{/section}
			</div>
			<div class="col-md-4">
				<h2><a href="/articles/">Статьи</a></h2>
				{section name="n" loop="$articles" max="5"}
					<h4><a href="/articles/{$articles[n].id}/{$articles[n].article_title|transliterate|escape|lower}">{$articles[n].article_title}</a> <small>{$articles[n].article_date|date_format}</small></h4>
				{/section}
			</div>
			<div class="col-md-4">
				<p>
					Осуществляем поставки оборудования и материалов по Южному Федеральному округу со складов в городах Ростов-на-Дону и Ставрополь.
				</p>
			</div>
		</div>
	</div>
</div>

{/strip}
<script type="application/javascript">
	{literal}
	$(document).ready(function(){

	});

	{/literal}
</script>
