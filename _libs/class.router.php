<?php

class router {
	protected $self = array();
	private static $__instance;
	public $_path;
	public $_router;
	public $_query;

	public $id;
	public $action;
	public $controller;

	function __construct($config = '') {
		$route = '';
		$this->_router = array('controller', 'action', 'id');
		$this->_path = array();
		$this->_query = $this->queryToArray($_SERVER['REQUEST_URI']);
		$url = preg_replace('/\?.*/', '', $_SERVER['REQUEST_URI']);
		$requestURI = explode('/', $url);
		$scriptName = explode('/',$_SERVER['SCRIPT_NAME']);

		for($i= 0;$i < sizeof($scriptName);$i++)
		      if ($requestURI[$i] == $scriptName[$i]) unset($requestURI[$i]);

		foreach ($requestURI as $value) {
			if (!empty($value)) $route[] = trim($value);
		}

		$this->_path = (!empty($route)) ? array_values($route) : array();
		$this->setRouter($config);
	}

	private static function queryToArray($qry)	{
		$result = array();
		if(strpos($qry,'=')) {
			if(strpos($qry,'?')!==false) {
				$q = parse_url($qry);
				$qry = $q['query'];
			}
		} else {
			return false;
		}

		foreach (explode('&', $qry) as $couple) {
			list ($key, $val) = explode('=', $couple);
			$result[$key] = urldecode($val);
		}

		return empty($result) ? false : $result;
	}

	// getInstance method
	public static function getInstance() {
		if (!self::$__instance) {
			self::$__instance = new self();
		}
		return self::$__instance;
	}

	function setRouter($config = '') {
		$route = '';
		if (!empty($config)) {
			$this->unsetRouter();
			foreach (explode('/', $config) as $value) if (!empty($value)) $route[] = trim($value);
			if (count($route)) {
				$this->_router = $route;
			}
		}

		if (count($this->_router)) {
			foreach ($this->_router as $k => $v) {
				$this->{$v} = (isset($this->_path[$k])) ? $this->_path[$k] : false;
			}
		}

	}

	function unsetRouter() {
		foreach ($this->_router as $var) unset($this->self[$var]);
	}
}