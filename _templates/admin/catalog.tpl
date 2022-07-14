<div class="row">
	<div class="col-md-4">
		<div class="panel panel-default">
			<div class="panel-heading">
				<h3 class="panel-title">Разделы каталога</h3>
			</div>
			<div class="panel-body" id="tree"></div>
			<script type="text/javascript">
				var currentPath = [{if $path != ''}{section name=id loop="$path"}{$path[id].category_id}{if !$smarty.section.id.last},{/if}{/section}{/if}];
				//path = JSON.stringify(path);
				{literal}
				$(function(){
					$('#tree').fancytree({
						//keyboard: false,
						//tabbable: 0,
						extensions: ["dnd"],
						icons: false,
						source: { url: "/admin/catalog/getTreeChildrens" },
						lazyLoad: function(e, data){
							data.result = {
								url: "/admin/catalog/getTreeChildrens",
								data: {key: data.node.key}
							}
						},
						dnd: {
							preventVoidMoves: true,
							preventRecursiveMoves: true,
							autoExpandMS: 100,
							onDragStart: function(node) {return true;},
							onDragEnter: function(node, sourceNode) {return true;},
							onDrop: function(node, sourceNode, hitMode, ui, draggable) {
								sourceNode.moveTo(node, hitMode);
							}
						},
						postProcess: function (e, data) {},
						loadChildren: function(e, data) {
							//console.log(data.node);
							var nodeLevel = data.node.getLevel();
							//console.log(nodeLevel, currentPath);
							if (nodeLevel + 1 <= currentPath.length && data.tree.getNodeByKey(currentPath[nodeLevel].toString()).isFolder())  data.tree.getNodeByKey(currentPath[nodeLevel].toString()).setExpanded(true);
							if (nodeLevel + 1 == currentPath.length) data.tree.getNodeByKey(currentPath[nodeLevel].toString()).setFocus(true);
						},
						init: function(e, data) {},
						activate: function(e, data) {},
						click: function(e, data) {
							if (data.node.folder && data.targetType == 'title') {
								document.location.href="/admin/catalog/viewCategory/" + data.node.key;
							} else if (data.targetType == 'title') {
								document.location.href="/admin/catalog/viewItems/" + data.node.key;
							}
						}
					});
					// $.ui.fancytree.debugLevel = 0;

				});
			</script>
			{/literal}
		</div>

		<a href="/admin/catalog/addCategory/0" class="btn btn-default btn-block">Добавить главный раздел</a>
	</div>
	<div class="col-md-8">
		<ol class="breadcrumb">
			<li><a href="/admin/catalog/">Каталог</a></li>
			{section name=id loop="$path"}
				{if $smarty.section.id.last && !isset($item)}
					<li>{$path[id].category_title}<li>
				{else}
					<li><a href='/admin/catalog/viewCategory/{$path[id].category_id}'>{$path[id].category_title}</a></li>
				{/if}
			{/section}
		</ol>

		<!-- Nav tabs -->

		{if ($action == 'viewCategory' || $action == 'viewItems')}
			<ul class="nav nav-tabs">
				<li class="{if ($action == 'viewCategory')}active{/if}"><a href="/admin/catalog/viewCategory/{$category.category_id}">Раздел</a></li>
				<li class="{if ($action == 'viewItems')}active{/if}{if ($category.is_leaf == 'false')} disabled{/if}"><a href="/admin/catalog/viewItems/{$category.category_id}">Товары</a></li>

				{if ($action == 'viewItems')}
					<li class="pull-right"><a class="" href="/admin/catalog/addItem/{$category.category_id}" id="">Добавить товар</a></li>
				{elseif ($action == 'viewCategory')}
					{if ($category.is_leaf == 'true' && !$items)}<li class="pull-right"><a href="/admin/catalog/deleteCategory/{$category.category_id}" class="warning" onclick="return confirm('Подтвердите, что вы хотите удалить данный раздел.');">Удалить</a></li>{/if}
					{if ($category.single_child == 'true' && $items)}<li class="pull-right"><a href="/admin/catalog/deleteCategory/{$category.category_id}" class="warning" onclick="return confirm('Подтвердите, что вы хотите удалить выбранный раздел. Все товары, которые принадлежат ему будут перемещены в родительский раздел. Данная операция необратима!');">Удалить</a></li>{/if}

					<li class="pull-right"><a class="" href="/admin/catalog/addCategory/{$category.category_id}" id="">Создать раздел</a></li>
					<li class="pull-right"><a class="" href="/admin/catalog/editCategory/{$category.category_id}">Редактировать</a></li>

				{/if}
			</ul>
		{/if}

		{if ($action == 'viewCategory')}{include file="catalog-viewCategory.tpl"}{/if}
		{if ($action == 'viewItems')}{include file="catalog-viewItems.tpl"}{/if}
		{if ($action == 'editCategory')}{include file="catalog-editCategory.tpl"}{/if}
		{if ($action == 'editItem')}{include file="catalog-editItem.tpl"}{/if}
		{if ($action == 'addCategory')}{include file="catalog-addCategory.tpl"}{/if}
		{if ($action == 'addItem')}{include file="catalog-addItem.tpl"}{/if}

	</div>
</div>
