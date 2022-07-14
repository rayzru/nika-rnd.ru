<?php

include_once '_init.php';

$router->setRouter('/controller/action/id');

if (!$admin->logged && $router->controller != 'auth') $page->redirect("/admin/auth");

$smarty->assign('action', $router->action);
$smarty->assign('admin', $admin);

$admin->catchLogout();

// jquery
$page->addScript("//ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js");
$page->addScript("//ajax.googleapis.com/ajax/libs/jqueryui/1/jquery-ui.min.js");

//bootstrap
$page->addCSS("//netdna.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css");
$page->addScript("//netdna.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js");

// FontAwesome
$page->addCSS("//netdna.bootstrapcdn.com/font-awesome/4.1.0/css/font-awesome.min.css");

//table DND
$page->addScript("/admin/js/jquery.tablednd.min.js");

// uploader
$page->addCSS("/_libs/fileUploader/fileuploader.css");
$page->addScript("/_libs/fileUploader/fileuploader.js");

// stuff
$page->addScript("/admin/js/stuff.js");

// fancytree
$page->addCSS("/admin/js/fancytree/skin-win8/ui.fancytree.css");
$page->addScript("/admin/js/fancytree/jquery.fancytree-all.js");

// select2
$page->addCSS("/admin/js/select2/select2.css");
$page->addCSS("/admin/js/select2/select2-bootstrap.css");
$page->addScript("/admin/js/select2/select2.js");
$page->addScript("/admin/js/select2/select2_locale_ru.js");

// DataTables
$page->addCSS("/admin/js/dataTables/1.10/examples/resources/bootstrap/3/dataTables.bootstrap.css");
$page->addScript("/admin/js/dataTables/1.10/media/js/jquery.dataTables.js");
$page->addScript("/admin/js/dataTables/1.10/examples/resources/bootstrap/3/dataTables.bootstrap.js");

// tinyMCE
// $page->addScript("/_libs/tiny_mce/jquery.tinymce.js");
// $page->addScript("/admin/js/tinymce_settings.js");

// WYSIWYG
$page->addCSS("/_libs/bootstrap-editor/dist/bootstrap3-wysihtml5.min.css");
$page->addScript("/_libs/bootstrap-editor/dist/bootstrap3-wysihtml5.all.min.js");
$page->addScript("/_libs/bootstrap-editor/dist/locales/bootstrap-wysihtml5.ru-RU.js");

$page->addScript("/_libs/blockUI/jquery.blockUI.js");

$page->addScript("/js/jquery.bootstrap-growl.min.js");

$page->addCSS("/admin/css/admin.css");

if ($router->controller !='') {
	switch ($router->controller) {
		case "auth":
			if ((isset($_SESSION['admin_logged']) && $_SESSION['admin_logged']) || (isset($_SESSION['manager_logged']) &&  $_SESSION['manager_logged']) ) $page->redirect("/admin");

			if (isset($_POST) && !empty($_POST)) {
				if ($admin->auth($_POST['login'], $_POST['password'])) {
					$page->redirect("/admin");
				} else {
					$smarty->assign('error', 'Не верно указаны логин/пароль или ваш IP за пределами допустимых.');
				};
			}
			$page->addCSS("/admin/css/login.css");
			$smarty->assign('ip', getClientIP());
			break;
		case "units":
			if (!isset($directories)) $directories = new directories();
			switch ($router->action) {
				case "delete" :
					$directories->delete($router->id);
					header("Location: /admin/". $router->controller);
					break;
				case "add":
					if (isset($_POST) && !empty($_POST)) {
						$directories->add($_POST['title'], $_POST['unit']);
						header("Location: /admin/". $router->controller);
					}
					break;
				case "edit":
					if (isset($_POST) && !empty($_POST)) {
						$directories->update($_POST['id'], $_POST['title'], $_POST['unit']);
						header("Location: /admin/". $router->controller);
					}
					$smarty->assign('feature', $directories->get($router->id));
					break;
				default:
					$smarty->assign('features', $directories->get());
					break;
			}
			break;
		case "articles":
			if (!isset($articles)) $articles = new articles();
			if (isset($router->action) && $router->action != "") {

				switch ($router->action) {
					case "add":
					case "edit":
						if (!empty($_POST)) {
							if (isset($_POST['id'])) {
								$articles->update($_POST['id'], $_POST['article_title'], $_POST['article_text'],  $_POST['category_id']);

							} else {
								$article_id = $articles->add($_POST['article_title'], $_POST['article_text'],  $_POST['category_id']);

							}

							if ($_POST['article_keywords_values'] != '') {
								$articles->emptyArticleKeywords($router->id);
								$item_keywords = explode(',', $_POST['article_keywords_values']);
								foreach ($item_keywords as $keyword) {
									$articles->addArticleKeyword($router->id, $keyword);
								}
							}

							$page->redirect("/admin/articles/");
						}
						$smarty->assign('template', 'articles-form.tpl');

						$smarty->assign('categories', $articles->assocCategories($articles->getCategories()));
						if ($router->action == 'edit' && isset($router->id)) {
							$article = $articles->getArticle($router->id);
							$smarty->assign('article', $article);
							$smarty->assign('article_keywords', $articles->getArticleKeywords($router->id));
							$catalog = new catalog();
							$smarty->assign('category', $catalog->getCategoryInfo($article['category_id']));
						}
						break;
					case "delete":
							$articles->delete($router->id);
							$page->redirect("/admin/articles");
						break;
					case "getArticleKeywords":
						$smarty->assign('keywords', $articles->getArticleKeywords($router->id));
						$smarty->display('keywords-json.tpl');
						die();
						break;
					case "getKeywords" :
						$smarty->assign('keywords', $articles->getKeywords( isset($_GET['q']) ? $_GET['q'] : ""));
						$smarty->display('keywords-json.tpl');
						die();
						break;
				}
			} else {
				$smarty->assign('articles', $articles->getGroupedContent());
				$smarty->assign('action', 'list');

			}
			break;
		case "content":
			if (!isset($content)) $content = new content();

			if (isset($_POST) && !empty($_POST)) {
				switch ($router->action) {
					case "content_form":
						$content = new content();
						$content->update($_POST['content_id'], $_POST['content_label'], $_POST['content_title'], $_POST['content_text']);
						header("Location: /admin/?mod=content&action=content");
						break;
				}
			}

			if (isset($_GET['action']) && $_GET['action'] != "") {
				$smarty->assign('action', $_GET['action']);
				switch ($_GET['action']) {
					case "content" :
						if (isset($_GET['id']) && $_GET['id'] != '') {

						} else {
							$smarty->assign('content', $content->get_content());
						}
						break;
					case "content_get":
						$smarty->assign('content', $content->get($_GET['id']));
						$smarty->display('content_content_json.tpl');
						exit(1);
						break;
				}
			}
			break;
		case "news":
			if (!isset($news)) $news = new content();
			if (isset($router->action) && $router->action == "") $page->redirect('/admin/news/list');
			switch ($router->action) {
				case "list" :
					$smarty->assign('news', $news->getContentByType('news'));
					break;
				case "delete" :
					$news->delete($router->id);
					$page->redirect('/admin/news/list');
				case "edit" :
				case "add" :
					if (isset($_POST) && !empty($_POST)) {
						if ($_POST['content_title'] == '') $errors[] = 'Отсутствует заголовок новости';
						if ($_POST['content_text'] == '') $errors[] = 'Отсутствует содержимое новости';

						if (isset($errors) && !empty($errors)) {
							$smarty->assign('errors', $errors);

							$smarty->assign('news', array(
								'content_title' => $_POST['content_title'],
								'content_text' => $_POST['content_text']
							));
						} else {

							if ($_POST['content_id'] != '') {
								$news->update(
									array(
										'content_id' => $_POST['content_id'],
										'content_title' => $_POST['content_title'],
										'content_text' => $_POST['content_text']
									)
								);
							} else {
								$news->add(array('content_title' => $_POST['content_title'], 'content_text' => $_POST['content_text']));
							}
							$page->redirect('/admin/news/list');
						}
					} else {
						if ($router->action == 'edit') $smarty->assign('news', $news->getById($router->id));
					}

					break;

				case "viewNews" :
					// 1= 1
					if (isset($router->id) && $router->id != '')
						$smarty->assign('news', $news->getById($router->id));
					break;
			}
			break;
		case "other":
			$page->addCSS("/_libs/bootstrap-select/css/bootstrap-select.min.css");
			$page->addScript("/_libs/bootstrap-select/js/bootstrap-select.min.js");
			$page->addScript("/_libs/bootstrap-select/js/i18n/defaults-ru_RU.min.js");

			if (!isset($content)) $content = new content();
			if (isset($router->action) && $router->action != "") {
				switch ($router->action) {
					case "parseArticuls":
						$items = array();
						$ids = array();
						if (isset($_POST['articuls']) && $_POST['articuls'] != '') {
							$catalog = new catalog();
							preg_match_all('/([a-zA-Z0-9]+)/', $_POST['articuls'], $matches);
							$keys = $matches[1];
							foreach ($keys as $key) {
								$item = $catalog->getItemByKey($key);
								if ($item) {
									$items[] = $item;
									$ids[] = $item['item_id'];
								}
							}
							$ids_serialized = implode($ids, ',');
						}
						echo json_encode(array('ids' => $ids_serialized, 'items' => $items, 'success' => true));
						die(1);
						break;
					case "changePrices" :
						if (isset($_GET['filename']) && $_GET['filename'] != '') {
							$inputFileName = $_SERVER['DOCUMENT_ROOT'] . '/admin/upload/' . $_GET['filename'];
							$inputFileType = PHPExcel_IOFactory::identify($inputFileName);
							$objReader = PHPExcel_IOFactory::createReader($inputFileType);
							$objXLS = $objReader->load($inputFileName);
							$objWorksheet = $objXLS->getActiveSheet();
							$data = array();
							$k = 0;
							$catalog = new catalog();
							foreach ($objWorksheet->getRowIterator() as $row) {
								$cellIterator = $row->getCellIterator();
								$cellIterator->setIterateOnlyExistingCells(false);
								$status = false;
								foreach ($cellIterator as $i => $cell) {
									if ($i == 0) {
										$val = $cell->getValue();
										if (preg_match('/([a-zA-Z0-9])+/', $val)) {
											$status = true;
										};
									} elseif ($i == 1 && $status) {
										$data[$val] = $cell->getValue();
										if (is_numeric($data[$val])) {
											$catalog->setPriceByKey($val, $data[$val]);
										};
										$status = false;
									}
								}
							}
						}
						@unlink($inputFileName);
						echo json_encode(array('success' => true));
						die(1);
						break;
					case "changeNames" :
						if (isset($_GET['filename']) && $_GET['filename'] != '') {
							$inputFileName = $_SERVER['DOCUMENT_ROOT'] . '/admin/upload/' . $_GET['filename'];
							$inputFileType = PHPExcel_IOFactory::identify($inputFileName);
							$objReader = PHPExcel_IOFactory::createReader($inputFileType);
							$objXLS = $objReader->load($inputFileName);
							$objWorksheet = $objXLS->getActiveSheet();
							$data = array();
							$k = 0;
							$catalog = new catalog();
							foreach ($objWorksheet->getRowIterator() as $row) {
								$cellIterator = $row->getCellIterator();
								$cellIterator->setIterateOnlyExistingCells(false);
								$status = false;
								foreach ($cellIterator as $i => $cell) {
									if ($i == 0) {
										$val = $cell->getValue();
										if (preg_match('/([a-zA-Z0-9])+/', $val)) {
											$status = true;
										};
									} elseif ($i == 1 && $status) {
										$data[$val] = $cell->getValue();
										if ($catalog->getItemByKey($val)) {
											$catalog->setTitleByKey($val, $data[$val]);
											$status = false;
										}
									}
								}
							}
						}
						@unlink($inputFileName);
						echo json_encode(array('success' => true));
						die(1);
						break;
					case "content_get":
						$smarty->assign('content', $content->get($_GET['id']));
						$smarty->display('content_content_json.tpl');
						exit(1);
						break;
					case "operate":
						if (isset($_POST['articuls']) && $_POST['articuls'] != '') {
							$ids = $_POST['articuls'];
							$operation = $_POST['operation'];
							$catalog = new catalog();

							if ($operation == 'hidden') {
								$catalog->hideItems($ids);
								echo json_encode(array('message' => 'Перечень товаров скрыт', 'success' => true));
							} elseif ($operation == 'visible') {
								$catalog->showItems($ids);
								echo json_encode(array('message' => 'Перечень товаров помечен как видимый', 'success' => true));
							} elseif ($operation == 'available') {
								$catalog->setItemsAvailable($ids);
								echo json_encode(array('message' => 'Перечень товаров помечен как достпный в наличии', 'success' => true));
							} elseif ($operation == 'unavailable') {
								$catalog->setItemsUnavailable($ids);
								echo json_encode(array('message' => 'Перечень товаров помечен как недостпный в наличии', 'success' => true));
							} elseif ($operation == 'temp') {
								$catalog->setItemsTempUnavailable($ids);
								echo json_encode(array('message' => 'Перечень товаров помечен как временно отсутствующий', 'success' => true));
							} elseif ($operation == 'delete') {
								$catalog->deleteItems($ids);
								echo json_encode(array('message' => 'Перечень товаров помечен на удаление', 'success' => true));
							} elseif ($operation == 'price_warn') {
								$catalog->setItemsPriceWarn($ids);
								echo json_encode(array('message' => 'Предупреждение о розничной цене изменено у перечня товаров.', 'success' => true));
							} elseif ($operation == 'price_notwarn') {
								$catalog->setItemsPriceNotWarn($ids);
								echo json_encode(array('message' => 'Предупреждение о розничной цене изменено у перечня товаров.', 'success' => true));
							} elseif ($operation == 'delete') {
								$catalog->deleteItems($ids);
								echo json_encode(array('message' => 'Перечень товаров помечен на удаление', 'success' => true));
							}
						}
						//
						die(1);
						break;					}
			}
			break;
		case "service":

			if (isset($router->action) && $router->action != "") {
				switch ($router->action) {
					case "recalculateCatalogTree":
						if ($_SERVER['REQUEST_METHOD'] === 'POST') {
							if (!isset($catalog)) $catalog = new catalog();
							$catalog->rebuildCategoryTree();
							$catalog->reallocateLeafs();
							echo "done";
							die();
							break;
						} else {
							header($_SERVER['SERVER_PROTOCOL'] . ' Request Error', true, 400);
							echo 'oops';
						}
				}
			}
			break;
		case "reviews":
			if (!isset($catalog)) $catalog = new catalog();
			if (isset($router->action) && $router->action == "") header('Location:/admin/reviews/list');

			$page->addScript('/js/raty/jquery.raty.js');
			$page->addCSS('/js/raty/jquery.raty.css');

			if ($router->action) {
				switch ($router->action) {
					case "list":
						$smarty->assign('reviews', $catalog->getReviews(0, !isset($_GET['filter'])));
						$smarty->assign('filter', (isset($_GET['filter'])) ? true : false);
						break;
					case "delete":
						if (isset($_POST['ids'])) {
							foreach($_POST['ids'] as $id) {
								$catalog->deleteReview($id);
							}
							echo 'ok';
							die();
						} else {
							$catalog->deleteReview($router->id);
							$page->redirect('/admin/qa/');
						}

						$page->redirect('/admin/reviews/');
						break;
					case "update":
						if (isset($_POST['approved'])) {

							$approved = (isset($_POST['resolve'])) ? 1 : $_POST['approved'];
							if ($catalog->updateReview($router->id, $approved, $_POST['review'])) {
								$page->redirect('/admin/reviews/');
							};
						}
						$smarty->assign('review', $catalog->getItemReview($router->id));
						break;
				}
			}
			break;
		case "catalog":
			if (!isset($catalog)) $catalog = new catalog();
			if ($router->action) {
				switch ($router->action) {
					case "getTreeBranch":
						$categories = $catalog->getCategoriesTree(0, $router->id);
						header('Content-Type: application/json');
						echo (json_encode($categories));
						die();
						break;
					case "toggleCommissionItem":
						$res = $catalog->toggleCommissionItem($router->id);
						header('Content-Type: application/json');
						echo (json_encode($res));
						die();
						break;
					case "getTreeChildrens":
						$key = (isset($_GET['key'])) ? $_GET['key'] : 0;
						//$categories = $catalog->getCategories($key, 0);
						$categories = $catalog->getCategories($key);
						$smarty->assign('nodes', $categories['data']);
						$smarty->display('tree_json.tpl');
						die();
						break;
					case 'itemDelete':
						$cid = $catalog->getItemCategoryId($router->id);
						if (isset($router->id)) {
							$catalog->deleteItem($router->id);
						}
						$page->redirect("/admin/catalog/viewItems/" .$cid . '#items');
						break;
					case "deleteNewItem" :
						$catalog->deleteNewItem($router->id);
						header("Location: /admin/");
						break;
					case "mark_toggle" :
						$catalog->toggleCategoryFeatureMark($_GET['cid'], $_GET['feature_id']);
						header("Location: /admin/?mod=" . $_GET['mod'] . "&cid=" . $_GET['cid'] . "#features");
						break;
					case "keyword_delete" :
						die();
						break;
					case "getCategoryKeywords" :
							if (isset($_GET['q'])) {
								$smarty->assign('query', $_GET['q']);
								$smarty->assign('keywords', $catalog->getCategoryKeywords($router->id, $_GET['q']));
							} else {
								$smarty->assign('keywords', $catalog->getCategoryKeywords($router->id));
							}

							$smarty->display('keywords-json.tpl');
							exit(0);
						break;
					case "getCategoryImage" :
						echo $catalog->getCategoryImage($router->id);
						die(1);
						break;
					case "getCategoriesWOImages" :
						echo json_encode($catalog->getCategoriesWOImages($_GET['skip'], $_GET['limit']));
						die(1);
						break;
					case "getItemsWOImages" :
						echo json_encode($catalog->getItemsWOImages($_GET['skip'], $_GET['limit']));
						die(1);
						break;
					case "itemsoptions" :
							if (isset($_GET['cid'])) {
								$smarty->assign('category_id', $_GET['cid']);
								$smarty->assign('items', $catalog->getItemsByCategory($_GET['cid']));
							}
							$smarty->display('items_json.tpl');
							exit(0);
						break;
					case "getItemKeywords":
							$smarty->assign('keywords', $catalog->getItemKeywords($router->id));
							$smarty->display('keywords-json.tpl');
							die();
						break;
					case "getKeywords" :
							if (isset($_GET['q'])) {
								$smarty->assign('query', $_GET['q']);
								$smarty->assign('keywords', $catalog->getKeywordsList($_GET['q']));
							} else {
								$smarty->assign('keywords', $catalog->getKeywordsList());
							}

							$smarty->display('keywords-json.tpl');
							die();
						break;
					case "item_get":
							$smarty->assign('item', $catalog->getItem($_GET['id']));
							$smarty->display('catalog_item_json.tpl');
							exit(1);
						break;
					case "itemsSaveOrder":
							$catalog->reorder($_GET['iT']);
							exit(1);
						break;
					case "sortItems":
							$cid = $_GET['cid'];

							$catalog->sortItems($_GET['order'], $cid);
							header("Location: /admin/?mod=catalog&cid=$cid#items");
							// sort done
							exit(1);
						break;
					case "addItemFeature":
							if ($_POST['feature_id'] != '') {
								if ($catalog->addItemFeature($router->id, $_POST['feature_id'], $_POST['value'])) {
									echo "true";
								} else {
									echo "false";
								}
							}
							exit(1);
						break;


					case "deleteCategoryImage":
							if ($router->id) echo json_encode($catalog->deleteCategoryImage($router->id));
							die();
						break;
					case "deleteCategory":
						if (isset($router->id) && $router->id != '') {
							$pid = $catalog->deleteCategory($router->id);
							$catalog->moveItems($router->id, $pid);
						}

						$page->redirect('/admin/catalog/viewCategory/' . $pid);

						break;
					case "deleteCategoryFeature":
							$catalog->deleteCategoryFeature($router->id, $_POST['id']);
							die();
						break;
					case "addCategoryFeature":
							$catalog->addCategoryFeature($router->id, $_POST['id']);
							die();
						break;
					case "load_category_features":
							if ($_GET['cid'] != '') {
								$smarty->assign('category_features', $catalog->getCategoryFeatures($_GET['cid']));
								$smarty->display('catalog_category_features_json.tpl');
							}
							exit(1);
						break;
					case "deleteItemFeature":
							if ($catalog->deleteItemFeature($router->id, $_POST['feature_id'])) {
								echo "success";
							}
							exit(1);
						break;
					case "delete_item_features":
							if ($catalog->deleteItemFeatures($_GET['item_id'])) {
								$smarty->assign('item', $catalog->getItem($_GET['item_id']));
								$smarty->display('catalog_item_json.tpl');
							}
							exit(1);
						break;
					case "cloneFeatures":
							$catalog->cloneItemFeatures($router->id, $_POST['from_id']);
							echo json_encode($catalog->getItemFeatures($router->id));
							exit(1);
							break;
					case "get_item_data":
						$smarty->assign('item', $catalog->getItem($_GET['item_id']));
						$smarty->display('catalog_item_json.tpl');
						exit(1);
						break;
					case "setDefaultImage":
							if ($item_id = $catalog->setDefaultItemImage($router->id)) {
								$smarty->assign('images', $catalog->getItemImages($item_id));
								echo $smarty->fetch('catalog-itemImages.tpl');
							}
						exit();
						break;
					case "viewCategory":
						$smarty->assign('cid', $router->id);
						$smarty->assign('path', $catalog->getPath($router->id));
						$smarty->assign('category', $catalog->getCategoryInfo($router->id));
						break;
					case "editCategory":
						if (!empty($_POST)) {
							$showImage = (isset($_POST['show_image'])) ? 'true' : 'false';
							$category_view = (isset($_POST['category_view'])) ? $_POST['category_view'] : 'icons';

							$catalog->updateCategory($router->id, $_POST['category_title'], $_POST['category_alternative_title'], $_POST['category_description'], $showImage, $category_view, (isset($_POST['active'])?1:0));

							if ($_POST['category_keywords_values'] != '') {
								$catalog->emptyCategoryKeywords($router->id);
								$item_keywords = explode(',', $_POST['category_keywords_values']);
								foreach ($item_keywords as $keyword) {
									$catalog->addCategoryKeyword($router->id, $keyword);
								}
							}

							$page->redirect("/admin/{$router->controller}/viewCategory/{$router->id}");
						} else {
							$smarty->assign('cid', $router->id);
							$smarty->assign('path', $catalog->getPath($router->id));
							$smarty->assign('category', $catalog->getCategoryInfo($router->id));
							$smarty->assign('category_keywords', $catalog->getCategoryKeywords($router->id));
							$smarty->assign('features', $catalog->getCategoryFeaturesList());
							$fa = $catalog->getCategoryFeaturesId($router->id);
							$smarty->assign('featuresAssigned', $fa);
						}
						break;
					case "editItem":
						if (isset($_POST) && !empty($_POST)) {

							$showImage = (isset($_POST['item_show_image'])) ? 'true' : 'false';
							$item_new = (isset($_POST['item_new'])) ? 1 : 0;
							$commission = (isset($_POST['commission'])) ? 1 : 0;
							$price_warn = (isset($_POST['price_warn'])) ? 1 : 0;

							if ($catalog->updateItem(
								$router->id,
								$_POST['item_title'],
								$_POST['item_alt_title'],
								$_POST['item_key'],
								$_POST['item_description'],
								$showImage,
								$_POST['item_price'],
								$price_warn,
								$_POST['item_unit'],
								$_POST['item_availability'],
								$_POST['item_active'],
								$_POST['category_id'],
								$item_new,
								$commission,
								$_POST['arrives_in'])) {
							}

							if (isset($_POST['feature']) && !empty($_POST['feature']))$catalog->updateItemFeatures($router->id, $_POST['feature']);

							if ($_POST['item_keywords_values'] != '') {
								$catalog->emptyItemKeywords($router->id);
								$item_keywords = explode(',', $_POST['item_keywords_values']);
								foreach ($item_keywords as $keyword) {
									$catalog->addItemKeyword($router->id, $keyword);
								}
							}


							if (isset($_POST['return'])) {
								$page->redirect('/admin/catalog/viewItems/' . $_POST['category_id']);
							} else {
								$page->redirect('/admin/catalog/editItem/' . $router->id);
							}

						} else {
							$smarty->assign('id', $router->id);
							$item = $catalog->getItem($router->id);
							if ($item) {
								$smarty->assign('item', $item);
								$smarty->assign('item_keywords', $catalog->getItemKeywords($router->id));
								$smarty->assign('cloneItems', $catalog->getItemsByCategory($catalog->getItemCategoryId($router->id)));
								$smarty->assign('features_list', $catalog->getCategoryFeaturesList($router->id));
								$smarty->assign('path', $catalog->getPath($catalog->getItemCategoryId($router->id)));
								$smarty->assign('category', $catalog->getCategoryInfo($catalog->getItemCategoryId($item['item_id'])));
							} else {
								$smarty->assign('error', "Данная позиция не доступна");
							}
						}

						break;
					case "addItem":
						if (isset($_POST) && !empty($_POST)) {

							$item_new = (isset($_POST['item_new'])) ? 1 : 0;
							$commission = (isset($_POST['commission'])) ? 1 : 0;
							$price_warn = (isset($_POST['price_warn'])) ? 1 : 0;
							$showImage = 1;

							$item_id = $catalog->insertItem(
								$router->id,
								$_POST['item_title'],
								$_POST['item_alt_title'],
								$_POST['item_key'],
								$_POST['item_description'],
								$showImage,
								$_POST['item_price'],
								$price_warn,
								$_POST['item_unit'],
								$_POST['item_availability'],
								$_POST['item_active'],
								$item_new,
								$commission,
								$_POST['arrives_in']
							);

							if ($item_id) {
								if (isset($_POST['continue_editing'])) {
									$page->redirect('/admin/catalog/editItem/' . $item_id);
								} else {
									$page->redirect('/admin/catalog/viewItems/' . $router->id);
								}


							} else {
								assign_post_vars('item', array('item_title', 'item_alt_title', 'item_description', 'item_price', 'price_warn', 'item_unit', 'item_availability', 'item_active', 'item_new'), $smarty);
								//$smarty->assign('item', );
							}

						} else {
							$smarty->assign('path', $catalog->getPath($router->id));
							$smarty->assign('category', $catalog->getCategoryInfo($router->id));
						}

						break;
					case "getLeafCategories":
						if ($router->id != '') {
							$smarty->assign('category', $catalog->getCategoryInfo($router->id));
							$smarty->display('catalog_category_info_json.tpl');
						} else {
							$smarty->assign('categories', $catalog->getLeafCategoriesListByTerm($_GET['q']));
							$smarty->display('catalog_leaf_categories_json.tpl');
						}
						die(0);
						break;
					case "getCategoriesJson":
						if ($router->id != '') {
							$smarty->assign('category', $catalog->getCategoryInfo($router->id));
							$smarty->display('catalog_category_info_json.tpl');
						} else {
							$smarty->assign('categories', $catalog->getCategoriesListByTerm($_GET['q']));
							$smarty->display('catalog_leaf_categories_json.tpl');
						}
						die(0);
						break;
					case "viewItems":
						if ($catalog->isLeafCategory($router->id)) {
							$smarty->assign('path', $catalog->getPath($router->id));
							$smarty->assign('items', $catalog->getItemsByCategory($router->id, false));
							$smarty->assign('category', $catalog->getCategoryInfo($router->id));
							$smarty->assign('features', $catalog->getCategoryFeatures($router->id));
							$smarty->assign('features_list', $catalog->getCategoryFeaturesList($router->id));

							$smarty->assign('categories', $catalog->getCategoriesTree(0));
						}
						break;
					case "addCategory":
						$smarty->assign('path', $catalog->getPath($router->id));
						if (isset($_POST) && !empty($_POST)) {
							$errors = array();
							if ($_POST['category_title'] == '') $errors[] = 'Наименование категории должно быть заполнено';
							$category_id = $catalog->addCategory(($router->id == 0) ? null : $router->id, $_POST['category_title'], $_POST['category_alternative_title'], $_POST['category_description'], (isset($_POST['active'])?1:0));
							$page->redirect("/admin/catalog/viewCategory/" . $category_id);
						}
						break;
					case "category_feature_add":
						$marked = isset($_POST['keyword']) ? 'true' : 'false';
						$catalog->addCategoryFeature($_POST['category_id'], $_POST['feature_id'], $marked);
						header("Location: /admin/?mod=" . $_POST['mod'] . "&cid=" . $_POST['category_id'] . "#features");
						break;
					/*case "category_add_keyword":
						$catalog->addCategoryKeyword($_POST['cid'], $_POST['keyword']);
						die();
						break;
					case "category_delete_keyword":
						$catalog->deleteCategoryKeyword($_POST['cid'], $_POST['keyword']);
						die();
						break;*/
					case "save_item_features":
						if ($catalog->saveItemFeatures($_POST['features'], $_POST['item_id'])) {
							$smarty->assign('item', $catalog->getItem($_POST['item_id']));
							$smarty->display('catalog_item_json.tpl');
						}
						exit(1);
						break;
					case "getItemImages":
						$smarty->assign('images', $catalog->getItemImages($router->id));
						echo $smarty->fetch('catalog-itemImages.tpl');
						exit();
						break;
					case "deleteItemImage":
						//$item_id = $catalog->getItemByImage($router->id);
						$item_id = $catalog->deleteItemImage($router->id);
						$smarty->assign('images', $catalog->getItemImages($item_id));
						echo $smarty->fetch('catalog-itemImages.tpl');
						exit();
						break;
					case "item_image_upload":
						if (!empty($_FILES)) {
							//$upload = new upload();
							$handle = new upload($_FILES['qqfile']);
							if ($handle->uploaded) {
								$handle->file_new_name_body   = md5(date("YmdHisu"));
								$handle->image_resize         = true;
								$handle->image_x              = 800;
								$handle->image_ratio_y        = true;
								$handle->process($_SERVER['DOCUMENT_ROOT'] . '/images/catalog/');
								if ($handle->processed) {
									$catalog->addItemImage($_POST['item_id'], $handle->file_dst_name);
									$handle->clean();
									$smarty->assign('item', $catalog->getItem($_POST['item_id']));
									$smarty->display('catalog_item_json.tpl');
								} else {
									// error
								}
							}

						}
						die();
						break;

					case "category_image_upload":
						if (!empty($_FILES)) {
							//$upload = new upload();
							$handle = new upload($_FILES['qqfile']);
							if ($handle->uploaded) {
								$handle->file_new_name_body   = md5(date("YmdHisu"));
								$handle->image_resize         = true;
								$handle->image_x              = 800;
								$handle->image_ratio_y        = true;
								$handle->process($_SERVER['DOCUMENT_ROOT'] . '/images/catalog/');
								if ($handle->processed) {
									$catalog->addCategoryImage($_POST['cid'], $handle->file_dst_name);
									$handle->clean();
									$smarty->assign('item', $catalog->getItem($_POST['item_id']));
									$smarty->display('catalog_item_json.tpl');
								} else {
									// error
								}
							}

						}
						die();
						break;
					default:
						break;
				}
			} else {

			}
			break;
		case "users":
			if (!isset($users)) $users = users::getInstance();

			if ($router->action) {
				switch ($router->action) {
					default:
						$smarty->assign('users', $users->get_users());
						break;
				}
			} else {
				//$page->addCSS()
				$smarty->assign('users', $users->get_users());
			}
			break;
		case "qa":
			if (!isset($qa)) $qa = new qa();
			if (isset($router->action) && $router->action == "") $page->redirect('/admin/qa/list');
			if ($router->action) {
				switch ($router->action) {
					case 'list':
						$router->setRouter('/controller/action/page');
						$status = (!empty($_GET['s'])) ? explode(',', $_GET['s']) : "queued";
						$qaPage = (isset($router->page) && $router->page != '') ? $router->page : 1;
						$qaData = (!empty($status)) ? $qa->get(array('status' => $status, 'limit' => 20, 'page' => $qaPage)) : $qa->get(array('limit' => 20, 'page' => $qaPage));
						$smarty->assign('qa', $qaData['data']);
						$smarty->assign('qaPage', $qaPage);
						$smarty->assign('statuses', (isset($_GET['s']) ? $_GET['s'] : ""));
						$smarty->assign('qaPageSize', 20);
						$smarty->assign('qaItems', $qaData['count']);

						break;
					case 'mailAjax':
						try {
							$mail = new mailer();
							$mail->addAddress($_POST['email'], $_POST['name']);
							$mail->setSubject("Ответ на ваш вопрос на сайте " . strtoupper($_SERVER['SERVER_NAME']));
							$smarty->assign('emailTemplate', 'email-template-qa.tpl');
							$smarty->assign('title', "Ответ на ваш вопрос на сайте  " . $_SERVER['SERVER_NAME']);
							$smarty->assign('content', $_POST['content']);
							$message = $smarty->fetch('email-template.tpl');
							$mail->setMessage($message);

							if(!$mail->send()) {
								echo 'Mailer Error: ' . $mail->mailer->ErrorInfo;
							} else {
								if ($_POST['delete']) $qa->delete($_POST['id']);
								echo 'ok';
								die();
							};

						} catch (phpmailerException $e) {
							echo $e->errorMessage(); die();
						} catch (Exception $e) {
							echo $e->getMessage(); die();
						}

						die();
						break;
					case 'delete':
						if (isset($_POST['ids'])) {
							foreach($_POST['ids'] as $id) {
								$qa->delete($id);
							}
							echo 'ok';
							die();
						} else {
							$qa->delete($router->id);
							$page->redirect('/admin/qa/');
						}
						break;
					case 'update':
						if (isset($_POST) && !empty($_POST)) {
							$status = isset($_POST['resolve']) ? 'closed' : $_POST['status'];
							$qa->update(
								$_POST['id'],
								$_POST['question'],
								$_POST['answer'],
								$status,
								$_POST['active']
							);
							$page->redirect("/admin/qa");
						} else {
							$smarty->assign('qa', $qa->getByID($router->id));
						}
						break;
				}
			}
			break;
		case "orders":
			if (!isset($orders)) $orders = new orders();
			if (isset($router->action) && $router->action != "") {

				switch ($router->action) {
					case 'accept':
						$orders->setOrderStatus($router->id, 'queued', 'added');
						header('Location: /admin/orders/');
						break;
					case 'details':
						$smarty->assign('order_items', $orders->getOrderItems($router->id));
						$smarty->display('order_details.tpl');
						exit();
						break;
					case 'reject':
						$orders->setOrderStatus($router->id, 'rejected', 'added');
						header('Location: /admin/orders/');
						break;
					case 'restore':
						$orders->setOrderStatus($router->id, 'added', 'rejected');
						header('Location: /admin/orders/');
						break;
					case 'close':
						$orders->setOrderStatus($router->id, 'closed', 'queued');
						header('Location: /admin/orders/');
						break;
					case 'delete':
						$orders->setOrderStatus($router->id, 'deleted');
						header('Location: /admin/orders/');
						break;
				}
			} else {
				$smarty->assign('order_statuses', $orders->statuses);
				$status = (!empty($_GET['s'])) ? explode(',', $_GET['s']) : "added";
				$smarty->assign('orders', $orders->getOrders(0, $status));
			}
			break;
		default:
			break;
	}
} else {
	if (!isset($catalog)) $catalog = new catalog();
	if (!isset($orders)) $orders = new orders();
	if (!isset($users)) $users = users::getInstance();

	$smarty->assign('orders_statuses_count', $orders->getOrdersStatusesCount());
	$smarty->assign('order_statuses', $orders->statuses);
	$smarty->assign('orders_added', $orders->getOrders(0, 'added'));
	$smarty->assign('categoriesWOImages', $catalog->getCategoriesWOImages(0,5));
	$smarty->assign('itemsWOImages', $catalog->getItemsWOImages(0,5));
	$smarty->assign('users', $users->getNewUsers(5));
	$smarty->assign('new', $catalog->getNewItems());
	$smarty->assign('comm', $catalog->getAllCommissionItems());
}

if (!isset($orders)) $orders = new orders();
if (!isset($users)) $users = users::getInstance();
$smarty->assign('orders_count', $orders->getOrdersCount());
$smarty->assign('users_count', $users->get_users_count());

if (isset($toolbar_menu)) $smarty->assign('toolbar', $toolbar_menu);

$smarty->assign('controller', $router->controller);
$smarty->assign('page' , $page);
$smarty->display('index.tpl');