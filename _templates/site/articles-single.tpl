{include file="page-title.tpl" title=$article.article_title }

<div class="container">
	<div class="row">
		<div class="col-md-9">
			<p class="text-muted">{$article.article_date|date_format:"%d %m %Y"}</p>

			{$article.article_text}

		</div>
		<div class="col-md-3">
			<!-- Перечень последних новостей -->
		</div>
	</div>
</div>
}
