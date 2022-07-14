<?php
class admin {
	
	public $logged = FALSE;
	
	function  __construct() {
		//$this->db = new database();
		$this->logged = isset($_SESSION['admin_logged']) || isset($_SESSION['manager_logged']);
	}
	
	function __destruct() {
		//
	}
	
	function auth($username, $pass) {
		if ($username == ADMIN_NAME && $pass == ADMIN_PASS || ($username == MANAGER_NAME && $pass == MANAGER_PASS && MANAGER_IP == getClientIP())) {
			$_SESSION[$username . '_logged'] = true;
			$this->logged = true;
			return true;
		}
		return false;
	}

	function catchLogout() {
		if (false !== strpos($_SERVER['REQUEST_URI'], 'logout')) {
			unset($_SESSION['admin_logged']);
			unset($_SESSION['manager_logged']);
			$this->logged = false;
			header("Location: " . removeQSVar($_SERVER['REQUEST_URI'], 'logout'));
		}
	}

	function is_logged() {
		return $this->logged;
	}
}