<ol class="breadcrumb">
	<li><a href="/admin">Главная</a></li>
	<li class="active">Обслуживание</li>
</ol>

<h1>Сервисное обслуживание</h1>
<div class="row">
	<div class="col-md-4" id="step1">
		<button id="rebuildTreeButton" class="btn btn-default">
			Пересчитать дерево каталога товаров
		</button>
	</div>
</div>

{literal}
<script>
jQuery(function($){
	$('#rebuildTreeButton').on('click', function(){
		$('#rebuildTreeButton').button('loading');
		$.post('/admin/service/recalculateCatalogTree', function(response){
			$('#rebuildTreeButton').button('reset');
		});

	});

});
</script>
{/literal}