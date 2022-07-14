<?php
//set_include_path($_SERVER['DOCUMENT_ROOT']);

include_once '_init.php';

$router->setRouter('/controller/action/id');

$page->addScript("/js/site.js");
$page->addCSS("/css/style.css");

$captcha = new captcha();

$controllers = array('articles', 'my', 'catalog', 'news', 'services', 'about', 'qa', 'contacts', '404');

if ($router->controller != '' && in_array($router->controller, $controllers)) {
	$smarty->assign('controller', $router->controller);
	switch ($router->controller) {
		case '404':
			header($_SERVER["SERVER_PROTOCOL"] . " 404 Not Found", TRUE, 404);
			$template = "404.tpl";
			break;
		case 'articles':
			$router->setRouter("/controller/id/");
			$articles = new articles();

			if ($router->id != '') {
				$article = false;
				if (is_numeric($router->id)) $article = $articles->getArticle($router->id);
				if (!$article) {
					$page->error404();
					$template = '404.tpl';
				} else {
					$template = 'articles-single.tpl';
					$smarty->assign('article', $article);
					$page->title = $article['article_title'];
					$article_keywords = $articles->getArticleKeywords($router->id);
					foreach ($article_keywords as $kw) $page->addKeyword($kw['keyword']);

					$smarty->assign('breadcrumbs', array(array('title' => 'Статьи', 'path' => '/articles/'), array('title' => $article['article_title'], 'path' => '/articles/' + $article['id'])));
				}
			} else {
				$template = 'articles.tpl';
				$smarty->assign('breadcrumbs', array(array('title' => 'Статьи', 'path' => '/articles/')));
				$smarty->assign('articles', $articles->getList());
			}
			break;
		case 'catalog':
			$catalog = new catalog();
			// every catalog page has search bar
			$template = "{$router->controller}-{$router->action}.tpl";

			switch ($router->action) {
				case 'viewCategory':
					if (!is_numeric($router->id)) {
						$page->redirect('/404', 404);
						$template = '404.tpl';
					} else {
						$categoryInfo = $catalog->getCategoryInfo($router->id);
						$smarty->assign('category', $categoryInfo);
						$smarty->assign('items', $catalog->getCategories($router->id, true));
						$smarty->assign('path', $catalog->getPath($router->id));
						$page->description = ($categoryInfo['category_description'] != '') ? $categoryInfo['category_description'] : $categoryInfo['category_alternative_title'];
						$page->title = $categoryInfo['category_title'];

						$category_keywords = $catalog->getCategoryKeywords($router->id);
						foreach ($category_keywords as $kw) $page->addKeyword($kw['keyword']);

						$articles = new articles();
						$smarty->assign('articles', $articles->getList(array('category' => $router->id)));
					}
					break;
				case 'viewItems':
					if (!is_numeric($router->id)) {
						$page->error404();
						$template = '404.tpl';
					} else {
						$page->addScript('/js/jquery.bootstrap-growl.min.js');
						$categoryInfo = $catalog->getCategoryInfo($router->id);
						if (!$categoryInfo) {
							$page->error404();
							$template = '404.tpl';
						} else {
							$smarty->assign('category', $categoryInfo);
							$smarty->assign('items', $catalog->getItemsByCategory($router->id));
							$smarty->assign('path', $catalog->getPath($router->id));
							$template = $router->controller . '-' . $router->action . '-' . $categoryInfo['category_view'] . '.tpl';
							$articles = new articles();
							$smarty->assign('articles', $articles->getList(array('category' => $router->id)));

							$category_keywords = $catalog->getCategoryKeywords($router->id);
							foreach ($category_keywords as $kw) $page->addKeyword($kw['keyword']);

							$page->description = ($categoryInfo['category_description'] != '') ? $categoryInfo['category_description'] : $categoryInfo['category_alternative_title'];
							$page->title = $categoryInfo['category_title'];
						}
					}

					break;
				case 'viewItem':
					if (!is_numeric($router->id) || !$catalog->isItemVisible($router->id)) {
						$page->redirect('/404/', 404);
						$template = '404.tpl';
					} else {
						$path = $catalog->getPath($catalog->getItemCategoryId($router->id));

						if ($path) {
							$popularPID = (isset($_COOKIE['pop'])) ? json_decode($_COOKIE['pop']) : new stdClass();
							$categoryPID = $path[0]['category_id'];
							setcookie("pop", "", time() - 3600);
							$categoryInfo = $catalog->getCategoryInfo($categoryPID);
							if (isset($popularPID->{$categoryPID})) {
								$popularPID->{$categoryPID}++;
							} else {
								$popularPID->{$categoryPID} = 1;
							}
							setcookie('pop', json_encode($popularPID), strtotime('+30 days'), '/');
							$smarty->assign('path', $path);
						}

						$smarty->assign('category', $catalog->getCategoryInfo($catalog->getItemCategoryId($router->id)));
						$item = $catalog->getItem($router->id);
						$smarty->assign('item', $item);
						$item_keywords = $catalog->getItemKeywords($router->id);
						foreach ($item_keywords as $kw) $page->addKeyword($kw['keyword']);
						$smarty->assign('inCart', $orders->checkCartItem($router->id));

						$smarty->assign('reviews', $catalog->getItemReviews($router->id, true));
						$smarty->assign('rating', $catalog->getItemRating($router->id));
						$qa = new qa();
						$smarty->assign('qa', $qa->getByItem($router->id));

						//$smarty->assign('image', $catalog->getItemImageFile($router->id));

						if ($user->logged) {
							$smarty->assign('ranked', $catalog->isItemRanked($router->id, $user->account->id));
							$page->addScript('/js/jquery.bootstrap-growl.min.js');
							$page->addScript('/js/raty/jquery.raty.js');
							$page->addCSS('/js/raty/jquery.raty.css');
						}

						$page->title = $item['item_title'];
						$page->description = ($item['item_description'] != '') ? strip_tags($item['item_description']) : "";

						//$captcha->set();
						$smarty->assign('captcha', $captcha->get());

					}
					break;
				case 'addReview':
					if (isset($_POST['score']) && $_POST['review'] != '' && mb_strlen($_POST['review']) > 20) {
						if ($catalog->setItemReview($router->id, $_POST['score'], $_POST['review'], $user->account->id)) {
							echo 'ok';
							die();
						};
					}
					echo 'error';
					die();
					break;
				case 'fastSearch':
					$smarty->assign('results', $catalog->searchItems($router->_query['term']));
					header('Content-Type: application/javascript');
					$smarty->display('catalog-search-json.tpl');
					die();
					break;
				case 'compareItems':
					if (empty($router->id)) $page->redirect("/catalog/");

					$itemsIds = explode(",", $router->id);
					if (!is_array($itemsIds)) $page->redirect("/catalog/viewItem/" . $itemsIds);

					$page->title = "Сравнение товаров";

					$smarty->assign('items', $catalog->getItemsArray($itemsIds));
					//$smarty->assign('itemsFeatures', $catalog->getItemsFeatures($itemsIds));
					$smarty->assign('featuresData', $catalog->getFeaturesArray());
					$smarty->assign('features', $catalog->fetchFeatures($itemsIds));

					break;
				case 'search':
					$smarty->assign('breadcrumbs', array(array('title' => 'Каталог', 'path' => '/catalog/'), array('title' => 'Поиск', 'path' => '/catalog/search')));
					$searchQuery = $router->_query['q'];
					if (isset($searchQuery) && mb_strlen($searchQuery) > 2) {
						$page->title = "Поиск &laquo;" . $searchQuery . "&raquo;";
						$items = $catalog->searchItems($searchQuery);
						$smarty->assign('items', $items);
						$smarty->assign('searchQuery', $searchQuery);
					} else {
						if (mb_strlen($searchQuery) <= 2) $errors[] = 'Для поиска введите больше двух символов.';
					}

					if (empty($errors)) {

					}
					$page->addScript('/js/jquery.bootstrap-growl.min.js');
					break;
				case 'commission':
					$smarty->assign('comm', $catalog->getAllCommissionItems());
					break;
				default:
					if ($router->action != '') {
						//$page->redirect('/404', 404);
						$template = '404.tpl';
					} else {
						$smarty->assign('categories', $catalog->getCategoriesTree());
						$page->addScript('/js/masonry.pkgd.min.js');
						//$page->addCSS('/css/catalog-icons.css');
						$page->title = 'Весь каталог';
						$smarty->assign('breadcrumbs', array(array('title' => 'Каталог', 'path' => '/catalog/')));
						$template = 'catalog-viewCatalog.tpl';
					}
					break;
			}
			break;
		case 'news':
			$router->setRouter('/controller/id');

			$news = new content();

			if ($router->id != '') {
				$template = 'news-single.tpl';
				$cnt = $news->get($router->id);
				$smarty->assign('breadcrumbs', array(array('title' => 'Новости', 'path' => '/news/'), array('title' => $cnt['content_title'], 'path' => '')));
				$smarty->assign('news', $cnt);
				$page->title = $cnt['content_title'];
			} else {
				$template = 'news.tpl';
				$smarty->assign('breadcrumbs', array(array('title' => 'Новости', 'path' => '/news/')));
				$smarty->assign('news', $news->getContentByType());
			}
			break;
		case 'about':
			$router->setRouter('/controller');
			$template = 'about.tpl';
			break;
		case 'services':
			$router->setRouter('/controller/subpage');
			$content = new content();
			// every catalog page has search bar
			$page->addScript("/_libs/select2/select2-ru.min.js");
			$page->addCSS('/_libs/select2/select2.css');
			$page->addCSS('/_libs/select2/select2-bootstrap.css');

			if ($router->action != '') {
				$template = "services-{$router->action}.tpl";
			} else {
				$template = 'services.tpl';
			}
			break;
		case 'qa':
			$router->setRouter('/controller/action/id');
			$qa = new qa();
			switch ($router->action) {
				case 'add':
					if (isset($_POST['question']) && $_POST['question'] != '') {
						$username = ($user->logged) ? $user->account->name : $_POST['name'];
						$email = ($user->logged) ? $user->account->email : $_POST['email'];
						$phone = ($user->logged) ? "" : $_POST['phone'];

						if ($_POST['captcha'] != $captcha->calculate()) {
							echo 'captcha error';
							die();
						}
						$captcha->set();
						echo $qa->add($_POST['question'], $username, $email, '', '', $router->id) ? 'ok' : "error";
					}
					die();
					break;
				default:
					break;
			}
			break;
		case 'contacts':
			if (isset($_POST) && !empty($_POST) && $router->action == 'feedback') {
				$errors = array();
				if ($_POST['email'] == '') $errors[] = 'Вам следует заполнить поле для адреса.';
				if (!filter_var($_POST['email'], FILTER_VALIDATE_EMAIL)) $errors[] = 'Email задан не верно.';
				if ($_POST['name'] == '') $errors[] = 'Вам следует заполнить поле для имени.';
				if ($_POST['message'] == '') $errors[] = 'Возможно, вы позабыли что хотели что-то написать.';
				if (mb_strlen($_POST['message']) < 10) $errors[] = 'Нужно больше букв в сообщении. А то можно подумать, что вы ругаетесь.';
				if (empty($errors)) {
					if (!mail_utf8(MESSAGES_EMAIL, $_POST['email'], 'Сообщение с сайта ' . $_SERVER['SERVER_NAME'], $_POST['message'])) $errors = 'Что-то пошло не так. Сообщение не отправлено.';
				}

				$smarty->assign('errors', $errors);
				$smarty->display('errors.tpl');
				die();

			}
			$template = 'contacts.tpl';
			break;
		case 'my':

			$template = "{$router->controller}-{$router->action}.tpl";

			//$page->addScript("/_libs/select2/select2-ru.min.js");
			//$page->addCSS('/_libs/select2/select2.css');
			//$page->addCSS('/_libs/select2/select2-bootstrap.css');


			if (isset($_POST) && isset($_POST['username']) && isset($router->action) && $router->action == 'auth' && !$user->logged) {
				if ($user->auth($_POST['username'], $_POST['password'])) {
					$_SESSION['account'] = $user->account;
					$_SESSION['logged'] = $user->logged;
					if (isset($_POST['method']) && $_POST['method'] == 'ajax') {
						echo 'ok';
						exit(1);
					} else {
						header("Location: /my/cart");
					}
				} else {
					if (isset($_POST['method']) && $_POST['method'] == 'ajax') {
						echo 'error';
						exit(0);
					} else {
						$smarty->assign('signin_error', '');
					}
				}
			}

			$strictedActions = array('register', 'amnesia', 'amnesiaLink', 'amnesiaCured', 'agreement', 'activate', 'reactivate', 'getCurrency');

			if (!$user->logged && !in_array($router->action, $strictedActions)) {
				$template = 'my-auth.tpl';
				$smarty->assign('breadcrumbs', array(array('title' => 'Кабинет', 'path' => '/my/'), array('title' => 'Приемная', 'path' => '/my')));
			} else {
				switch ($router->action) {
					case 'getCartItems':
						echo $orders->getCartItems();
						die();
						break;
					case 'getCurrency':
						echo json_encode(getCurrencyRates());
						die();
						break;
					case 'clearCart':
						$orders->clearCart();
						$page->redirect('/my/cart');
						break;
					case 'genPassword':
						echo generatePassword();
						die();
						break;
					case 'profile':
						$errors = array();
						if (isset($_POST) && !empty($_POST)) {
							if ($_POST['name'] == '') $errors[] = 'Заполните поле Имя.';
							//if ($_POST['password'] == '' || $_POST['password2'] == '') $errors[] = 'Вы не указали пароль в одном из полей.';
							if ($_POST['password'] != $_POST['password2']) $errors[] = 'Введенные пароли должны совпадать.';

							if (!empty($_POST['password']) && !preg_match('$\S*(?=\S{6,})(?=\S*[a-zA-Z\d])\S*$', $_POST['password'])) $errors[] = 'Пароль может содержать только латинские буквы и цифры и быть не короче 6 символов';

							if (empty($errors)) {
								if ($_POST['password'] != '') {
									$user->updateProfile($user->account->id, $_POST['name'], $_POST['phone'], md5($_POST['password']));

									try {
										$mail = new mailer();
										$mail->addAddress($user->account->email, $_POST['name']);
										$mail->setSubject("Обновление данных пользователя на сайте " . strtoupper($_SERVER['SERVER_NAME']));
										$smarty->assign('emailTemplate', 'email-template-updatePassword.tpl');
										$smarty->assign('title', "Изменение пароля на сайте " . $_SERVER['SERVER_NAME']);
										$smarty->assign('email', $user->account->email);
										$smarty->assign('name', $_POST['name']);
										$smarty->assign('password', $_POST['password']);
										$message = $smarty->fetch('email-template.tpl');
										$mail->setMessage($message);

										if (!$mail->send()) $errors[] = 'Mailer Error: ' . $mail->mailer->ErrorInfo;

									} catch (phpmailerException $e) {
										echo $e->errorMessage();
										die();
									} catch (Exception $e) {
										echo $e->getMessage();
										die();
									}

								} else {
									$user->updateProfile($user->account->id, $_POST['name'], $_POST['phone']);
								}
								$_SESSION['account'] = $user->update();
								$page->redirect('/my/');
							}
						}

						if (!empty($errors)) $smarty->assign('errors', $errors);
						$smarty->assign('breadcrumbs', array(array('title' => 'Кабинет', 'path' => '/my/'), array('title' => 'Профиль', 'path' => '/my/profile')));
						break;
					case 'makeOrder':
						if (isset($_POST) && !empty($_POST)) {
							if (isset($_POST['recalc'])) {
								$orders->recalcCart($_POST['item']);
								$page->redirect('/my/cart/');
								die();
							} else {
								$order = $orders->orderCreate();
								// email notification
								try {
									$mail = new mailer();
									$mail->addAddress(NOTIFY_EMAIL);
									$mail->addAddress(NOTIFY_EMAIL2);
									$mail->setSubject("Поступил новый заказ №$order на сайте " . strtoupper($_SERVER['SERVER_NAME']));
									$smarty->assign('emailTemplate', 'email-template-newOrder.tpl');
									$smarty->assign('title', "Новый заказ №" . $order);
									$smarty->assign('order', $orders->getOrderDetails($order));
									$smarty->assign('orderItems', $orders->getOrderItems($order));
									$message = $smarty->fetch('email-template.tpl');
									$mail->setMessage($message);

									if (!$mail->send()) $errors[] = 'Mailer Error: ' . $mail->mailer->ErrorInfo;

								} catch (phpmailerException $e) {
									echo $e->errorMessage();
									die();
								} catch (Exception $e) {
									echo $e->getMessage();
									die();
								}
							}
							$page->redirect('/my/ordered/' . $order);
						}
						break;
					case 'ordered':
						$smarty->assign('orderNumber', $router->id);
						$template = 'my-ordered.tpl';
						break;
					case 'agreement':
						$smarty->assign('domainName', $_SERVER['SERVER_NAME']);
						$smarty->assign('breadcrumbs', array(
								array('title' => 'Кабинет', 'path' => '/my/'),
								array('title' => 'Пользовательское соглашение', 'path' => '/my/agreement')
							)
						);
						break;
					case 'add2Cart':
						$orders->addCart($router->id);
						$page->redirect('/my/');
						break;
					case 'add2CartAjax':
						if (isset($_POST['id']) && !empty($_POST['id'])) {
							$orders->addCart($_POST['id'], $_POST['qty']);
						}
						echo $orders->getCartItems();
						die();
						break;
					case 'deleteCartItem':
						$orders->deleteCartItem($router->id);
						echo $orders->getCartItems();
						die();
						break;

					case 'clearCart':
						$orders->clearCart();
						$page->redirect("/my/cart");
						break;
					case 'cart':
						$smarty->assign('cart', $orders->getCart());
						$smarty->assign('breadcrumbs', array(array('title' => 'Кабинет', 'path' => '/my/'), array('title' => 'Корзина', 'path' => '/my/cart')));
						break;
					case 'orders':
						if (isset($router->id) && $router->id != '') {
							if ($orders->getOrderOwnerId($router->id) != $user->account->id) $page->redirect("/my/orders");
							$smarty->assign('breadcrumbs', array(
									array('title' => 'Кабинет', 'path' => '/my/'),
									array('title' => 'Заказы', 'path' => '/my/orders'),
									array('title' => 'Заказ №' . $router->id, 'path' => '/my/orders/' . $router->id)
								)
							);

							$smarty->assign('orderData', $orders->getOrderDetails($router->id));

							$smarty->assign('order', $orders->getOrderItems($router->id));
							$smarty->assign('order_statuses', $orders->statuses);
							$smarty->assign('order_statuses_labels', $orders->labels);
							$smarty->assign('orderNumber', $router->id);
							$template = 'my-order.tpl';

						} else {
							$smarty->assign('orders', $orders->getOrders($user->account->id));

							$smarty->assign('order_statuses', $orders->statuses);
							$smarty->assign('order_statuses_labels', $orders->labels);
							$smarty->assign('breadcrumbs', array(array('title' => 'Кабинет', 'path' => '/my/'), array('title' => 'Заказы', 'path' => '/my/orders')));
						}
						break;
					case 'activate':
						if ($user->logged) $page->redirect("/my/");
						$template = ($user->activateUser($router->id)) ? 'my-activated.tpl' : 'my-notactivated.tpl';
						break;
					case 'reactivate':
						if ($user->logged) $page->redirect("/my/");
						//$template = ($user->activateUser($router->id)) ? 'my-activated.tpl' :  'my-notactivated.tpl';

						if (isset($_POST) && !empty($_POST)) {
							if ($_POST['email'] == '') $errors[] = 'Вам следует заполнить поле для адреса.';
							if (!$user->is_email($_POST['email'])) $errors[] = 'Вы знаете, почтовый адрес ' . $_POST['email'] . ' небыл зарегистрирован.';
							if (!filter_var($_POST['email'], FILTER_VALIDATE_EMAIL)) $errors[] = 'Email задан не верно.';
							$usrData = $user->getByEmail($_POST['email']);

							if (empty($errors)) {
								$user->setActivateKey($usrData->id);
								$template = 'my-registered.tpl';
							} else {
								$smarty->assign('errors', $errors);
								$template = 'my-notactivated.tpl';
							}

						}

						break;
					case 'register':
						if ($user->logged) $page->redirect("/my/");
						$errors = array();
						if (isset($_POST) && !empty($_POST)) {
							if ($_POST['name'] == '') $errors[] = 'Заполните поле Имя.';
							if ($_POST['email'] == '') $errors[] = 'Для регистрации требуется заполнить поле EMAIL в обязательном порядке.';
							if ($user->is_email($_POST['email'])) $errors[] = 'Пользователь с электронным адресом ' . $_POST['email'] . ' уже зарегистрирован';
							if (!filter_var($_POST['email'], FILTER_VALIDATE_EMAIL)) $errors[] = 'Email задан не верно.';
							if ($_POST['password'] == '' || $_POST['password2'] == '') $errors[] = 'Вы не указали пароль в одном из полей.';
							if ($_POST['password'] != $_POST['password2']) $errors[] = 'Введенные пароли должны совпадать.';
							if (!isset($_POST['argeegment'])) $errors[] = 'Что бы пройти регистрацию, вы должны согласится с нашими требованиями. Пожалуйста прочитайте пользовательское соглашение.';
							if (!preg_match('$\S*(?=\S{6,})(?=\S*[a-zA-Z\d])\S*$', $_POST['password'])) $errors[] = 'Пароль может содержать только латинские буквы и цифры и быть не короче 6 символов';

							if (empty($errors)) {
								if ($userid = $user->register($_POST['name'], $_POST['email'], $_POST['phone'], md5($_POST['password']))) {

									$key = $user->setActivateKey($userid);

									try {
										$mail = new mailer();
										$mail->addAddress($_POST['email'], $_POST['name']);
										$mail->setSubject("Подтверждение регистрации на сайте " . strtoupper($_SERVER['SERVER_NAME']) . ", активационное письмо");


										$smarty->assign('key', $key);
										$smarty->assign('emailTemplate', 'email-template-activate.tpl');
										$smarty->assign('title', "Активация");
										$smarty->assign('name', $_POST['name']);
										//$smarty->assign('message', $message);
										$smarty->assign('action', array('url' => '/my/activate/' . $key, 'title' => 'Активировать'));

										$message = $smarty->fetch('email-template.tpl');

										$mail->setMessage($message);

										if (!$mail->send()) {
											$errors[] = 'Mailer Error: ' . $mail->mailer->ErrorInfo;
										}

									} catch (phpmailerException $e) {
										echo $e->errorMessage(); //error messages from PHPMailer
										echo "errr";
										die();
									} catch (Exception $e) {
										echo $e->getMessage();
										echo "errr";
										die();
									}

									$template = 'my-registered.tpl';
								}
							} else {
								assign_post_vars('register', array('name', 'email', 'password', 'phone'), $smarty);
							}
						}

						if (!empty($errors)) $smarty->assign('errors', $errors);
						$smarty->assign('breadcrumbs', array(array('title' => 'Кабинет', 'path' => '/my/'), array('title' => 'Регистрация', 'path' => '/my/register')));
						break;
					case 'amnesia':
						if ($user->logged) $page->redirect("/my/");
						$smarty->assign('breadcrumbs', array(array('title' => 'Кабинет', 'path' => '/my/'), array('title' => 'Восстановление доступа', 'path' => '/my/amnesia')));

						if (isset($_POST) && !empty($_POST)) {
							if ($_POST['email'] == '') $errors[] = 'Вам следует заполнить поле для адреса.';
							if (!$user->is_email($_POST['email'])) $errors[] = 'Вы знаете, почтовый адрес ' . $_POST['email'] . ' небыл зарегистрирован.';
							if (!filter_var($_POST['email'], FILTER_VALIDATE_EMAIL)) $errors[] = 'Email задан не верно.';

							$usrData = $user->getByEmail($_POST['email']);
							//print_r($usrData);

							if (empty($errors) && !empty($usrData)) {

								$key = $user->setResetKey($usrData->id);

								try {
									$mail = new mailer();
									$mail->addAddress($usrData->email, $usrData->name);
									$mail->setSubject("Восстановление доступа на сайт " . strtoupper($_SERVER['SERVER_NAME']));

									$smarty->assign('key', $key);
									$smarty->assign('emailTemplate', 'email-template-amnesiaLink.tpl');
									$smarty->assign('title', "Сброс пароля");
									$smarty->assign('name', $usrData->name);
									$smarty->assign('action', array('url' => '/my/amnesiaLink/' . $key, 'title' => 'Получить новый пароль'));
									$message = $smarty->fetch('email-template.tpl');
									$mail->setMessage($message);

									if (!$mail->send()) {
										$errors[] = 'Mailer Error: ' . $mail->mailer->ErrorInfo;
									}

								} catch (phpmailerException $e) {
									echo $e->errorMessage(); //error messages from PHPMailer
									die();
								} catch (Exception $e) {
									echo $e->getMessage();
									die();
								}

								$template = 'my-amnesia-resetSent.tpl';
							} else {
								$smarty->assign('errors', $errors);
								//$template = 'my-amnesia.tpl';
							}

						}

						break;
					case 'amnesiaCured':
						break;
					case 'amnesiaLink':
						if ($user->logged) $page->redirect("/my/");
						$smarty->assign('breadcrumbs', array(array('title' => 'Кабинет', 'path' => '/my/'), array('title' => 'Восстановление доступа', 'path' => '/my/amnesia')));

						$usrData = $user->getByKey($router->id);
						//print_r($usrData);
						if ($usrData) {

							$newPassword = generatePassword();
							$user->updatePassword($usrData->id, $newPassword);

							$user->resetKey($usrData->id);

							try {
								$mail = new mailer();
								$mail->addAddress($usrData->email, $usrData->name);
								$mail->setSubject("Восстановление доступа на сайт " . strtoupper($_SERVER['SERVER_NAME']));

								$smarty->assign('password', $newPassword);
								$smarty->assign('emailTemplate', 'email-template-amnesiaDone.tpl');
								$smarty->assign('title', "Сброс пароля");
								$smarty->assign('name', $usrData->name);
								$smarty->assign('email', $usrData->email);
								$smarty->assign('action', array('url' => '/my/', 'title' => 'Войти с новым паролем'));
								$mail->setMessage($smarty->fetch('email-template.tpl'));

								if (!$mail->send()) {
									$errors[] = 'Mailer Error: ' . $mail->mailer->ErrorInfo;
								}

							} catch (phpmailerException $e) {
								echo $e->errorMessage(); //error messages from PHPMailer
								die();
							} catch (Exception $e) {
								echo $e->getMessage();
								die();
							}

							$page->redirect('/my/amnesiaCured/');

						} else {
							$smarty->assign('errors', $errors);
						}

						break;
					default:
						$smarty->assign('breadcrumbs', array(array('title' => 'Кабинет', 'path' => '/my/')));
						$template = 'my.tpl';
				}
			}
			break;
	}

} else {

	if ($router->controller != '') $page->redirect('/404');

	$categories = $catalog->getCategoriesTree(0);

	$popularPID = (isset($_COOKIE['pop'])) ? json_decode($_COOKIE['pop']) : new stdClass();

	foreach ($categories as $i => $category) {
		unset($categories[$i]['children']);
		$categories[$i]['sort_order'] = (isset($popularPID->{$category['id']})) ? $popularPID->{$category['id']} : -1;
	}

	$sorted = array_orderby($categories, 'sort_order', SORT_DESC);

	$news = new content();
	$smarty->assign('news', $news->getContentByType());

	if (!isset($articles)) $articles = new articles();

	$smarty->assign('articles', $articles->getList());

	$smarty->assign('categories', $sorted);

	$page->title = "НИКА";

	//for search
	//$page->addScript("/_libs/typeahead/typeahead.bundle.js");


	$page->addScript("/_libs/vegas/dist/vegas.min.js");
	$page->addCSS("/_libs/vegas/dist/vegas.min.css");


	$template = 'mainpage.tpl';
}

//debug($catalog->getCategories(0));
$smarty->assign('menucat', $catalog->getCategories(0));
$smarty->assign('template', $template);
$smarty->assign('page', $page);
$smarty->assign('user', $user);

if ($user->logged) $smarty->assign('cartItems', $orders->getCartItems());
if ($user->logged) $smarty->assign('cartTotal', $orders->getCartTotal());
if ($user->logged) $smarty->assign('cartData', $orders->getCart());

$smarty->assign('totalItems', $catalog->getItemsTotal());
$smarty->assign('contactPhone', CONTACT_PHONE);
$smarty->assign('contactPhone2', CONTACT_PHONE2);

$smarty->display('index.tpl');