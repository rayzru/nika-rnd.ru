<?php
error_reporting(E_ALL);
ini_set('display_errors', '1');

define('DB_HOST',	'127.0.0.1');
define('DB_USER',	'nika');
define('DB_PASS',	'');
define('DB_NAME',	'nika');

define('SENDER',    'robot@nika-rnd.ru');
define('SMTP_USER',	'www@nika-rnd.ru');
define('SMTP_PASS',	'');
define('SMTP_HOST',	'');
define('SMTP_PORT',	'');
define('SMTP_SECURE',	'ssl');
define('SMTP_AUTH',		true);

define('NOTIFY_EMAIL', 'info@nika-rnd.ru');
define('NOTIFY_EMAIL2', '');

define('CONTACT_PHONE', '');
define('CONTACT_PHONE2', '');


// Templates
define('TPL_CACHE',			'/_cache');
define('TPL_PATH',			'/_templates/site');
define('TPL_PATH_ADMIN',	'/_templates/admin');

// Manager access
define('MANAGER_NAME',	'manager');
define('MANAGER_PASS',	'');
define('MANAGER_IP',	'127.0.0.1');