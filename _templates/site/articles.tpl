{include file="page-title.tpl" title="Статьи" }

<div class="container">
	<div class="row">
		{section name="i" loop="$articles"}
			<article class="row">
				<h3>
					<a href="/articles/{$articles[i].id}/{$articles[i].article_title|transliterate|escape|lower}">{$articles[i].article_title}</a>
					<small>{$articles[i].article_date|date_format}</small>
				</h3>
				<p>{$article[i].article_text}</p>
			</article>
		{/section}
	</div>
</div>
