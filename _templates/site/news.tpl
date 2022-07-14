{include file="page-title.tpl" title="Новости" page_description=""}

<section id="content">
	<div class="content-wrap">
		<div class="container clearfix">

			<div class="postcontent nobottommargin clearfix">
				<div id="posts" class="post-timeline clearfix">
					<div class="timeline-border"></div>

					{section name="i" loop="$news"}

					<div class="entry clearfix">
						<div class="entry-timeline">
							{$news[i].content_date|date_format:"%d"} <span>{$news[i].content_date|date_format:"%b"}</span>
							<div class="timeline-divider"></div>
						</div>
						<div class="entry-image"></div>
						<div class="entry-title">
							<h2><a href="/news/{$news[i].content_id}/{$news[i].content_title|transliterate|escape|lower}">{$news[i].content_title}</a></h2>
						</div>
						<ul class="entry-meta clearfix">
							<li><a href="#"><i class="icon-user"></i> Компания Ника</a></li>
						</ul>
						<div class="entry-content">
							<p >{$news[i].content_text}</p>
							<a href="/news/{$news[i].content_id}/{$news[i].content_title|transliterate|escape|lower}"class="more-link">Подробнее</a>
						</div>
					</div>

					{/section}
				</div>
			</div>
		</div>
	</div>
</section>
