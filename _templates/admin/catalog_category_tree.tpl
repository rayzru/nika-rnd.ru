{strip}
{if $tree}
<ul>
{foreach from=$tree key=key item=item}
	<li {if $item.id==$cid}id="current_category"{/if}>
	{if $item.is_leaf == 'true'}
		<a href="#" onclick="setCategory(this);return false;" title="Выбрать &#0151; {$item.category_title|escape}" id="category_{$item.id}">{$item.category_title}</a>
	{else}
		<span  id="category_{$item.id}">{$item.category_title}</span>
	{/if}
	{include file="catalog_category_tree.tpl" tree=$item.children}</li>
{/foreach}
</ul>
{/if}
{/strip}