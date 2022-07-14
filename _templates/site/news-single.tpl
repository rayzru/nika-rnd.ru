{include file="page-title.tpl" title=$news.content_title}

<section id="content">
	<div class="content-wrap">
		<div class="container clearfix">

			<div class="postcontent nobottommargin clearfix">


				<div class="single-post nobottommargin">

					<div class="entry clearfix">

						<ul class="entry-meta clearfix">
							<li><i class="icon-calendar3"></i> {$news.content_date|date_format}</li>
							<li><a href="/about/"><i class="icon-user"></i> Компания Ника</a></li>
						</ul><!-- .entry-meta end -->
						<div class="entry-content notopmargin">
							{$news.content_text}
						</div>

					</div>
				</div>


			</div>
		</div>
	</div>
</section>
