{strip}{section name=img loop=$images}
<div class="col-md-4">
	<div id="image{$images[img].image_id}" class="thumbnail {if $images[img].default_image == 'true'}default{/if}" style="background-image: url(/images/catalog/100x100/{$images[img].image_file});">
		<button class="btn btn-sm btn-danger"  title="Удалить изображение" type="button"  data-loading-text="<i class='fa fa-reload fa-spin'></i>" onclick="if (confirm('Вы действительно хотите удалить изображение?')) deleteImage({$images[img].image_id});return false;"><i class="fa fa-times"></i></button>&nbsp;
		{if $images[img].default_image != 'true'}<button title="Установить в качестве изображения по умолчанию" type="button" data-loading-text="<i class='fa fa-reload fa-spin'></i>" class="btn btn-sm btn-default imageDefault" onclick="setDefaultImage({$images[img].image_id});return false;"><i class="fa fa-check"></i></button>{/if}
	</div>
</div>
{/section}
{/strip}