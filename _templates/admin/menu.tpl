
<div class="navbar navbar-default" role="navigation">
	<div class="container">
		<div class="collapse navbar-collapse">
			<ul class="nav navbar-nav">
				<li {if ('' == $controller)}class="active"{/if}><a href="/admin/">Главная</a></li>
				<li {if ('catalog' == $controller)}class="active"{/if}><a href="/admin/catalog">Каталог товаров</a></li>
				<li {if ('orders' == $controller)}class="active"{/if}><a href="/admin/orders">Заказы <span class="badge">{$orders_count}</span></a></li>
				<li {if ('users' == $controller)}class="active"{/if}><a href="/admin/users">Пользователи <span class="badge">{$users_count}</span></a></li>
				<li class="dropdown">
					<a href="#" class="dropdown-toggle" data-toggle="dropdown">Контент <b class="caret"></b></a>
					<ul class="dropdown-menu"  role="menu">
						<li {if ('news' == $controller)}class="active"{/if}><a href="/admin/news">Новости</a></li>
						<li {if ('articles' == $controller)}class="active"{/if}><a href="/admin/articles">Статьи</a></li>
						<li {if ('qa' == $controller)}class="active"{/if}><a href="/admin/qa">Вопросы/ответы</a></li>
						<li {if ('catalog' == $controller) && ('reviews' == $action)}class="active"{/if}><a href="/admin/reviews/list/">Отзывы о товарах</a></li>
					</ul>
				</li>
				<li class="dropdown">
					<a href="#" class="dropdown-toggle" data-toggle="dropdown">Настройки <b class="caret"></b></a>
					<ul class="dropdown-menu"  role="menu">
						<li {if ('units' == $controller)}class="active"{/if}><a href="/admin/units">Справочник свойств товаров</a></li>
						<li {if ('other' == $controller)}class="active"{/if}><a href="/admin/other">Операции</a></li>
						<li {if ('service' == $controller)}class="active"{/if}><a href="/admin/service">Сервисное обслуживание</a></li>
					</ul>
				</li>
			</ul>
			<ul class="nav navbar-nav navbar-right">
				<li><a href="?logout">Выйти</a></li>
				<li><a href="/">Сайт</a></li>
			</ul>
		</div>
	</div>
</div>
