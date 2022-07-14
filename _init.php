<?php
ini_set('display_errors', 'on');
ini_set('zlib.output_compression', 'On');
ini_set('zlib.output_compression_level', '1');

include_once '_config.php';
include_once '_libs/class.router.php';
include_once '_libs/functions.php';
include_once '_libs/smarty/Smarty.class.php';
include_once '_libs/zebraDatabase/class.database.php';
include_once '_libs/class.page.php';
include_once '_libs/class.catalog.php';
include_once '_libs/class.content.php';
include_once '_libs/class.users.php';
include_once '_libs/class.orders.php';
include_once '_libs/class.qa.php';
include_once '_libs/class.articles.php';
include_once '_libs/PHPMailer/PHPMailerAutoload.php';
include_once '_libs/class.mailer.php';
include_once '_libs/class.captcha.php';

session_start();

$smarty = new Smarty();

$smarty->template_dir 	= $_SERVER['DOCUMENT_ROOT'] . TPL_PATH;
$smarty->compile_dir 	= $_SERVER['DOCUMENT_ROOT'] . TPL_CACHE;
$smarty->compile_id 	= $_SERVER['SERVER_NAME'];

//$smarty->caching = Smarty::CACHING_LIFETIME_CURRENT;
//$smarty->debugging = true;

$smarty->assign('domain', $_SERVER['SERVER_NAME']);

$router = new router();

$db = database::getInstance();
$db->debug = true;
$db->log_path = $_SERVER['DOCUMENT_ROOT'] . TPL_CACHE;
//$db->cache_path = $_SERVER['DOCUMENT_ROOT'] . TPL_CACHE;

$page = new page();
$user = users::getInstance();
$orders = new orders();

$catalog = new catalog();

if ($user->logged) $orders->setUser($user->account->id);

if (false !== strpos($_SERVER['REQUEST_URI'], 'logout')) {
	unset($_SESSION['account']);
	$_SESSION['logged'] = false;
	$user->account = '';
	$user->logged = false;

	header("Location: " . removeQSVar($_SERVER['REQUEST_URI'], 'logout'));
}
