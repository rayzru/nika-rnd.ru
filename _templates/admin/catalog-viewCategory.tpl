<h1>{$category.category_title}</h1>
{if !$category.category_description}
	<p class="text-muted">Описание отсутствует</p>
{else}
	<p>{$category.category_description}</p>
{/if}
