{include file="page-title.tpl" title=$category.category_title }

<section id="content" style="margin-bottom: 0;">

	<div class="content-wrap">

		<div class="container clearfix">

			<div class="nobottommargin category-view {if !empty($category.category_description) && !empty($articles)}postcontent{/if}">

				<div id="shop" class="clearfix">

					{section name=i loop=$items.data}

						<div class="col_one_fourth noleftmargin {if $smarty.section.i.iteration mod 4 eq 0}col_last{/if}">

							<div class="feature-box center media-box fbox-bg">
								<div class="fbox-media">
									<a href="/catalog/{if $items.data[i].is_leaf == "true"}viewItems{else}viewCategory{/if}/{$items.data[i].category_id}/{$items.data[i].category_title|transliterate|lower}">
										<img src="/images/catalog/300x300/{if $items.data[i].image_file != ''}{$items.data[i].image_file}{else}image_blank.jpg{/if}" alt="{$items.data[i].category_title}">
									</a>
								</div>
								<div class="fbox-desc">
									<h4><a href="/catalog/{if $items.data[i].is_leaf == "true"}viewItems{else}viewCategory{/if}/{$items.data[i].category_id}/{$items.data[i].category_title|transliterate|lower}">
											{$items.data[i].category_title}
										</a></h4>
								</div>
							</div>

						</div>

					{/section}


				</div>

			</div>

			{if !empty($category.category_description) && !empty($articles)}
			<!-- Sidebar
			============================================= -->
			<div class="sidebar nobottommargin col_last">
				<div class="sidebar-widgets-wrap">

					{if !empty($category.category_description)}
						<div class="widget clearfix">
							<h4>Описание</h4>

							{$category.category_description}

						</div>
					{/if}

					{if !empty($articles)}
						<div class="widget clearfix">
							<h4>Статьи раздела</h4>

							<ul>
								{section name="id" loop="$articles"}
									<li>
										<a href="/articles/{$articles[id].id}/{$articles[id].article_title|transliterate|lower}">{$articles[id].article_title}</a>
									</li>
								{/section}
							</ul>
						</div>
					{/if}
				</div>
			</div><!-- .sidebar end -->
			{/if}

		</div>

	</div>

</section>