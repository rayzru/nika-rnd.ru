<?php
class users {

	private $db;

	public $account;
	public $logged = false;

	private static $instance;  // экземпляра объекта
	//private function __construct(){ /* ... @return Singleton */ }  // Защищаем от создания через new Singleton
	private function __clone()    { /* ... @return Singleton */ }  // Защищаем от создания через клонирование
	private function __wakeup()   { /* ... @return Singleton */ }  // Защищаем от создания через unserialize

	public static function getInstance() {    // Возвращает единственный экземпляр класса. @return Singleton
		if ( empty(self::$instance) ) {
			self::$instance = new self();
		}
		return self::$instance;
	}


	protected function __construct() {
		$this->db = database::getInstance();

		$this->account = null;
		$this->logged = false;

		// get user from session scratch
		if(isset($_SESSION) && isset($_SESSION['logged']) && isset($_SESSION['account'])) {
			$this->account = $_SESSION['account'];
			$this->logged = $_SESSION['logged'];
		}
	}


	public function getLoggedId() {
		return $this->logged ? $this->account->id : false;
	}

	public function get_users_count(){
		$this->db->query("
			SELECT
				u.id
			FROM
				users u
			");
		return $this->db->found_rows;
	}

	public function get_users(){
		if ($this->db->query("
			SELECT
			  u.name,
			  u.login,
			  u.email,
			  u.phone,
			  u.registered_date,
			  u.id
			FROM
			  users u
		")) {
			if ($this->db->found_rows > 0)  return $this->db->fetch_assoc_all();
		}
		return false;
	}

	function getNewUsers($limit = 10){
		if ($this->db->query("
			SELECT
			  u.name,
			  u.login,
			  u.email,
			  u.phone,
			  u.registered_date,
			  u.id
			FROM
			  users u
			ORDER BY
				u.registered_date DESC
			LIMIT $limit
		")) {
			if ($this->db->returned_rows > 0)  return $this->db->fetch_assoc_all();
		}
		return false;
	}

	function user_delete($id) {
		if ($id) return $this->db->delete('users', 'id = ?', array($id));
		return false;
	}

	function update() {
		if (isset($this->account->id)) {
			if ($this->db->query("SELECT * from users WHERE id = ?", array($this->account->id))) {
				$this->account = $this->db->fetch_obj();
				return $this->account;
			}
		}
		return false;
	}

	function updateProfile($id, $name, $phone, $password = '') {
		if (!empty($password)) {
			return $this->db->update('users', array('name'=> $name, 'phone' =>$phone, 'password' => $password), "id = ?", array($id));
		} else {
			return $this->db->update('users', array('name' => $name, 'phone' => $phone), "id = ?", array($id));
		}
	}

	function updatePassword($id, $password) {
		if ($this->db->update('users', array('password' => md5($password)), "id = ?", array($id))) return $id;
		return false;
	}

	function register($name, $email, $phone ,$password) {
		if ($this->db->insert('users', array('email' => $email, 'login' => $email, 'name' => $name, 'phone' => $phone, 'registered_date' => date('Y-m-d H:i:s'), 'password' =>  md5($password)))) {
			$user_id  = $this->db->insert_id();
			return $user_id;
		}
		return false;
	}

	function setActivateKey($id) {
		$userData = $this->getById($id);
		if (!$userData) return false;
		$key = sha1($userData->email . $userData->registered_date);
		if ($this->db->update('users', array('akey' => $key, 'is_active' => false, 'is_activated' => false), 'id = ?' , array($id))) {
			return $key;
		};
		return false;
	}

	function setResetKey($id) {
		$userData = $this->getById($id);
		if (!$userData) return false;
		$key = sha1($userData->email . $userData->registered_date);
		if ($this->db->update('users', array('akey' => $key), 'id = ?' , array($id))) return $key;
		return false;
	}

	function resetKey($id) {
		$userData = $this->getById($id);
		if (!$userData) return false;
		return $this->db->update('users', array('akey' => ""), 'id = ?' , array($id));
	}

	function activateUser($key) {
		$key = trim($key);
		$res = $this->db->dlookup('akey', 'users', 'akey = ?' ,array($key));
		if ($res != '') {
			$this->db->update('users', array('is_activated' => true, 'is_active' => true, 'akey' => ''), 'akey = ?', array($key));
			return true;
		}
		return false;
	}


	function mailProfileData($email, $pass) {
		$subject = "Данные регистрации на сайте " . strtoupper($_SERVER['SERVER_NAME']) .", письмо-уведомление";
		$message =
			"\r\nУважаемый пользователь, вы получили данное письмо, по причине успешной регистрации на сайте " . strtoupper($_SERVER['SERVER_NAME']) . "." .

			"\r\n\r\nНапоминаем вам, что вы сможете зайти в личный кабинет используя следующие данные:" .
			"\r\nЛогин: 		" . $email .
			"\r\nПароль:       " . $pass .

			"\r\n\r\nНи при каких обстоятельствах не отдавайте свой личный пароль сторонним людям," .
			"\r\nи не забывайте свой пароль." .

				"\r\n\r\nС уважением, ваш любимый робот " . $_SERVER['SERVER_NAME'];


		return mail_utf8($email, null, $subject, $message );
	}


	function auth($login, $password, $role = 'user') {
		$res = ($this->db->query("SELECT * from users WHERE (login = ? AND password = ?) OR (email = ? AND password = ?)", array($login, md5($password), $login, md5($password))));
		if ($res) {
			if ($this->db->found_rows == 1) {
				$this->account = $this->db->fetch_obj();
				$this->logged  = true;
			}
		}

		return $this->logged;
	}

	function getById ($id) {
		if ($this->db->query("SELECT * from users WHERE id = ?", array($id)))
			if ($this->db->found_rows == 1)
				return $this->db->fetch_obj();
		return false;
	}

	function update_key ($key, $id) {
		return $this->db->update('users', array('akey'=>$key), 'id = ?', array($id));
	}

	function getByEmail ($email) {
		if ($this->db->query("SELECT * from users WHERE email = ?", array($email)))
			if ($this->db->found_rows == 1)
				return $this->db->fetch_obj();
		return false;
	}


	function getByKey($key) {
		if ($this->db->query("SELECT * from users WHERE `akey` = ?", array($key)))
			if ($this->db->found_rows == 1)
				return $this->db->fetch_obj();
		return false;
	}

	function getEmail($id) {
			return $this->db->dlookup('email', 'users', 'id = ?', array($id));
		}

	function getId($login) {
		return $this->db->dlookup('id', 'users', 'login = ?', array($login));
	}

	function getKey($id) {
		return $this->db->dlookup('akey', 'users', 'id = ?', array($id));
	}


	function is_login($login) {
		$id = $this->db->dlookup('id', 'users', 'login = ?', array($login));
		if ($id !='') {
			return $id;
		} else {
			return false;
		}
	}

	function is_id($id) {
		if ($this->db->query("SELECT * from users WHERE id = ? ", array($id))) {
			return $this->db->returned_rows;
		}
		return false;
	}


	function is_email($email, $id = 0) {
		if ($id) {
			if ($this->db->query("SELECT * from users WHERE email = ? AND id <> ? ", array($email, $id))) {
				return $this->db->returned_rows;
			}
		} else {
			$id = $this->db->dlookup('id', 'users', 'email = ?', array($email));
			if ($id !='') {
				return $id;
			}
		}
		return false;
	}

	function __destruct() {	}


}
