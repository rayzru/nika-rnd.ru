<?php
include_once "Zebra_Database.php";

class database extends Zebra_Database {

	private static $instance;

   /**
	* @static
	* @return database
	*/

	public static function getInstance() {
		if (!self::$instance) {
			self::$instance = new database();
		}
		return self::$instance;
	}

    function __construct() {

		//$this->memcache_compressed = false;
		//$this->memcache_host = false;

		$this->memcache_host = '127.0.0.1';
		$this->memcache_port = 11211;
		$this->memcache_compressed = true;
		$this->caching_method = 'memcache';


		$this->connect(DB_HOST, DB_USER, DB_PASS, DB_NAME);

		$this->query("set character set UTF8");
		$this->query("set names UTF8");
    }
}