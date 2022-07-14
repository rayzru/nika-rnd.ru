<?php

include_once '../_config.php';
include_once '../_libs/functions.php';
include_once '../_libs/class.router.php';
include_once '../_libs/class.page.php';
include_once '../_libs/smarty/Smarty.class.php';
include_once '../_libs/zebraDatabase/class.database.php';
include_once '../_libs/class.admin.php';
include_once '../_libs/class.catalog.php';
include_once '../_libs/class.content.php';
include_once '../_libs/class.users.php';
include_once '../_libs/class.orders.php';
include_once '../_libs/class.qa.php';
include_once '../_libs/class.articles.php';
include_once '../_libs/class.directories.php';
include_once '../_libs/PHPMailer/PHPMailerAutoload.php';
include_once '../_libs/PHPExcel/Classes/PHPExcel.php';
include_once '../_libs/class.mailer.php';

session_start();

$db = database::getInstance();

$db->debug = true;

$page = new page();
$router = new router();
$smarty = new Smarty();

$smarty->template_dir 	= $_SERVER['DOCUMENT_ROOT'] . TPL_PATH_ADMIN;
$smarty->compile_dir 	= $_SERVER['DOCUMENT_ROOT'] . TPL_CACHE;
$smarty->compile_id     = 'admin';

$admin = new admin;