<?php
set_time_limit(0);
error_reporting(E_ALL);

$host='odisey.ru';
$scheme='http://';
$urls=array();
$content=NULL;

$engine_root = realpath(dirname(__FILE__));

// Функция для сбора ссылок
//echo '1';
include_once '_config.php';
include_once '_libs/functions.php';
include_once '_libs/zebraDatabase/class.database.php';
include_once '_libs/class.catalog.php';
include_once '_libs/class.articles.php';


$catalog = new catalog();

var_dump ('1');
die();

$articles = new articles();

$catalogItemsArray = $catalog->getItemsSEO();
foreach ($catalogItemsArray as $item) {
	$urls[] = $scheme . $host. '/catalog/viewItem/' . $item['item_id'] . '/' . transliterate($item['item_title']);
}

$catalogCategoriesArray = $catalog->getCategoriesSEO();
foreach ($catalogCategoriesArray as $item) {
	$urls[] = $scheme . $host. '/catalog/' . (($item['is_leaf'] == 'true') ? 'viewItems' : 'viewCategory') . '/' . $item['category_id'] . '/' . transliterate($item['category_title']);
}

$catalogArticlesArray = $articles->getArticlesSEO();
foreach ($catalogArticlesArray as $item) {
	$urls[] = $scheme . $host. '/articles/' . $item['id'] . '/' . transliterate($item['article_title']);
}

// Когда все ссылки собраны, то обрабатываем их и записываем в файлы sitemap.xml и sitemap.txt (должны быть права на запись)
$sitemapXML='<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.google.com/schemas/sitemap/0.84"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xsi:schemaLocation="http://www.google.com/schemas/sitemap/0.84 http://www.google.com/schemas/sitemap/0.84/sitemap.xsd">
<!-- Last update of sitemap '.date("Y-m-d H:i:s+06:00").' -->';
$sitemapTXT=NULL;
echo "2";
foreach($urls as $k) $sitemapXML.="\r\n<url><loc>{$k}</loc><changefreq>weekly</changefreq><priority>0.5</priority></url>";

$sitemapXML.="\r\n</urlset>";

$sitemapXML=trim(strtr($sitemapXML,array('%2F'=>'/','%3A'=>':','%3F'=>'?','%3D'=>'=','%26'=>'&','%27'=>"'",'%22'=>'"','%3E'=>'>','%3C'=>'<','%23'=>'#','&'=>'&')));

$fp=fopen($engine_root.'/sitemap.xml','w+');if(!fwrite($fp,$sitemapXML)){echo 'Ошибка записи!';}fclose($fp);