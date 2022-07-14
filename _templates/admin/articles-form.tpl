<ol class="breadcrumb">
	<li><a href="/admin">Главная</a></li>
	<li><a href="/admin/articles/">Статьи</a></li>
	<li class="active">{if $article.id!=''}Изменение статьи{else}Новая статья{/if}</li>
</ol>

<h1>{if $article.id!=''}Изменение статьи{else}Новая статья{/if}</h1>

<form method="post">

	{if $article.id!=''}<input type="hidden" name="id" value="{$article.id}" />{/if}
	<input type="hidden" name="category_id" id="category_id" value="{$article.category_id}" />

	{if isset($errors)}
		<div class="alert alert-warning">
			<h4>Обнаружены ошибки</h4>
			<ul>{section name='i' loop="$errors"}<li>{$errors[i]}</li>{/section}</ul>
		</div>
	{/if}

	<div class="form-group">
		<label for="title">Заголовок</label>
		<input type="text" name="article_title" class="form-control" id="title" placeholder="Введите заголовок" value="{$article.article_title|escape}">
	</div>

	<div class="form-group">
		<label>Категория</label>
		<div class="selectCategory" style="width: 100%;display: block;"></div>
	</div>

	<div class="panel panel-default">
		<div class="panel-heading">
			Ключевые слова
		</div>
		<div class="panel-body">
			<input type="text" name="article_keywords" id="article_keywords" value="" class="form-control">
			<input type="hidden" name="article_keywords_values" id="article_keywords_values" value="">
			{literal}
			<script type="application/javascript">
				$(function(){
					$('#article_keywords')
							.val([{/literal}{section name=k loop=$article_keywords}{if !$smarty.section.k.first},{/if}{$article_keywords[k].id}{/section}{literal}])
							.select2({
								placeholder: "Клчевые слова",
								minimumInputLength: 2,
								multiple: true,
								ajax: { // instead of writing the function to execute the request we use Select2's convenient helper
									url: "/admin/articles/getKeywords/",
									dataType: 'json',
									data: function (term, page) {
										return {
											q: term, // search term
											page_limit: 10,
											page: page
										};
									},

									results: function (data, page) {
										return {results: data.keywords};
									}
								},
								createSearchChoice: function(term, data) {

									if ($(data).filter( function() { return this.text.localeCompare(term)===0; }).length===0) {
										return {id:term, text:term};
									}
								},
								initSelection: function(element, callback) {
									$.ajax("/admin/articles/getArticleKeywords/{/literal}{$article.id}{literal}/", {
										dataType: "json"
									}).done(function(data) { callback(data.keywords); });
								},
								escapeMarkup: function (m) { return m; }
							}).on('change', function() {
								var selected = $('#article_keywords').select2('data');
								var str = "";
								$.each(selected, function(k, v){
									str = str +  ((str.length) ? ',' : '') + this.text
								});
								$('#article_keywords_values').val(str);
							});
				});
			</script>
			{/literal}
		</div>
	</div>


	<div class="form-group">
		<label for="content">Статья</label>
		<textarea class="form-control tinymce" name="article_text" id="content" placeholder="" rows="10">{$article.article_text|escape}</textarea>
	</div>

	<div>
		{if $article.id!=''}<a href="/admin/articles/delete/{$article.id}" class="btn btn-default pull-right" onclick="return confirm('Подтвердите удаление');">Удалить</a>{/if}
		<button type="submit" class="btn btn-success" onclick="$(this).addClass('disabled');">Сохранить</button>
		<a href="/admin/articles" class="btn btn-default">Отмена</a>
	</div>
</form>

{literal}
<script type="text/javascript">
	$(function(){

		$('#content').wysihtml5({
			locale:"ru-RU",
			image: false,
			blockquote: false,
			html: true,
			parserRules: {tags:{a:{set_attributes:{target:"_self",rel:""}}}}
		});

		$('.selectCategory').select2({
			placeholder: "Выберите раздел",
			minimumInputLength: 2,
			allowClear: true,
			quietMillis: 1000,
			ajax: {
				url: "/admin/catalog/getCategoriesJson/",
				dataType: 'json',
				data: function (term, page) {
					return {
						q: term, // search term
						page_limit: 10,
						page: page
					};
				},
				results: function (data, page) {return {results: data.categories};}
			}
		}){/literal}{if !empty($category) && $category != ''}
				.select2('data',{ldelim}id: {$category.category_id}, text: "{$category.category_title|escape}"{rdelim});{else};{/if}{literal}

		$('.selectCategory').on("select2-selecting", function(e) {
			$('#category_id').val(e.val);
		});
	});

</script>
{/literal}