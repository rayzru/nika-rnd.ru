<?php
class orders {

	private $db;
	private $user_id;

	public $statuses;

	function __construct() {
		$this->db = database::getInstance();
		$this->statuses = array('added' => 'Новый', 'queued' => 'Принят', 'rejected' => 'Отменен', 'closed' => 'Закрыт', 'deleted' => 'Удален');
		$this->labels = array('added' => 'success', 'queued' => 'info', 'rejected' => 'warning', 'closed' => 'default', 'deleted' => 'danger');

	}

	function clearCart() {
		return $this->db->delete('cart', 'user_id = ?', array($this->user_id));
	}


	function setOrderStatus($id, $status, $current_status = '') {
		$current_status_cond =  ($current_status) ? "AND order_status = '$current_status'" : '';
		//$user_cond = ($user_id) ? "AND user_id = $user_id" : "";
		$this->db->update('orders', array('order_status'=> $status), "id = ? $current_status_cond", array($id));
	}

	function getOrderDetails($id) {
		$this->db->query("SELECT * from orders where id = ?", array($id));
		return ($this->db->found_rows > 0) ? $this->db->fetch_assoc() : false;
	}

	function getOrderItems($id) {
		$this->db->query("
			SELECT
			  i.item_title,
			  i.item_key,
			  i.item_unit,
			  i.item_id,
			  o.quantity,
			  orders.order_date,
			  orders.order_status
			FROM
			  catalog_items i
			  RIGHT OUTER JOIN order_items o ON (i.item_id = o.item_id)
			  LEFT OUTER JOIN orders ON (o.order_id = orders.id)
			WHERE
				orders.id = ?
		", array($id));
		return $this->db->fetch_assoc_all();
	}

	function getOrdersCount() {
		$this->db->query("
			SELECT
				o.id
			FROM
				orders o
			");
		return $this->db->found_rows;
	}

	function getOrderOwnerId($order_id){
		return $this->db->dlookup('user_id', 'orders', 'id = ?', array($order_id));
	}

	function getOrdersStatusesCount() {
		$this->db->query("
			SELECT
				o.order_status,
				COUNT(o.id) as cnt
			FROM
				orders o
			GROUP BY
				o.order_status
			");
		return ($this->db->found_rows > 0) ? $this->db->fetch_assoc_all() : false;
	}


	function getOrders($user_id = 0, $status = '') {

		$status_cond = ($status == '') ? "" : (is_array($status) ? ("AND o.order_status IN ('" . implode("','", $status) . "')") : " AND o.order_status = '$status' ");

		if ($user_id) {
			$this->db->query("
				SELECT
					o.id as order_id,
					o.user_id as user_id,
					o.order_date as order_date,
					o.order_status as order_status,
					u.name as user_name,
					u.login as user_login,
					u.email as user_email,
					u.phone as user_phone,
					SUM(i.quantity) as all_items_count,
					COUNT(i.id) as items_count
				FROM
					orders o
				LEFT JOIN order_items i ON (o.id = i.order_id)
				LEFT JOIN users u ON (u.id = o.user_id)
				WHERE
					o.user_id = ?
					$status_cond
				GROUP BY
					o.id
				ORDER BY
					o.order_date DESC
			", array($user_id));
		} else {
			$this->db->query("
				SELECT
					o.id as order_id,
					o.user_id as user_id,
					o.order_date as order_date,
					o.order_status as order_status,
					u.name as user_name,
					u.login as user_login,
					u.email as user_email,
					u.phone as user_phone,
					SUM(i.quantity) as all_items_count,
					COUNT(i.id) as items_count
				FROM
					orders o
				LEFT JOIN order_items i ON (o.id = i.order_id)
				LEFT JOIN users u ON (u.id = o.user_id)
				WHERE
					1 = 1
					$status_cond
				GROUP BY
					o.id
				ORDER BY
					o.order_date DESC
			", array($user_id));
		}

		return ($this->db->found_rows > 0) ? $this->db->fetch_assoc_all() : false;
	}

	function orderCreate(){
		$this->db->insert('orders', array('user_id'=> $this->user_id, 'order_date' => date('Y-m-d H:i:s')));
		$order_id = $this->db->insert_id();
		$this->db->query("
			INSERT INTO order_items (item_id, quantity, order_id)
				SELECT c.item_id, c.quantity, ? FROM cart c WHERE c.user_id = ?
		", array($order_id, $this->user_id));
		$this->clearCart();
		return $order_id;
	}

	function getCart() {
		if ($this->user_id) {
			$this->db->query("
				SELECT c.*, i.*
				FROM cart c
				LEFT JOIN catalog_items i ON (i.item_id = c.item_id)
				WHERE c.user_id = ?
			", array($this->user_id));

			if ($this->db->found_rows > 0) return $this->db->fetch_assoc_all();
		}
		return false;
	}

	function checkCartItem($item_id) {
		$qty = $this->db->dlookup('quantity', 'cart', 'item_id = ? AND user_id = ?', array($item_id, $this->user_id));
		return ($qty != '') ? $qty : 0;
	}

	function purgeCart() {
		$this->db->delete('cart', 'quantity = 0 and user_id = ?', array($this->user_id));
	}

	function deleteCartItem($id) {
		$this->db->delete('cart', 'item_id = ? and user_id = ?', array($id, $this->user_id));
	}

	public function recalcCart($items) {
		foreach($items as $item => $qty) {
			$this->db->update('cart', array('quantity'=> $qty), 'item_id = ? and user_id = ?', array($item, $this->user_id));
		}
		$this->purgeCart();
	}

	function getCartItems () {
		$this->db->query('SELECT SUM(quantity) as qty, COUNT(id) as cnt  FROM cart WHERE user_id = ?', array($this->user_id));
		$num = $this->db->fetch_assoc();
		return !empty($num['qty']) ?  $num['qty'] : 0;
	}

	function getCartTotal () {
		$this->db->query('SELECT SUM(c.quantity * i.price) as total FROM cart c LEFT JOIN catalog_items i ON (c.item_id = i.item_id) WHERE c.user_id = ?', array($this->user_id));
		$num = $this->db->fetch_assoc();
		return !empty($num['total']) ?  $num['total'] : 0;
	}

	function _addCart($item_id, $qty = 1) {
		$real_qty = $this->checkCartItem($item_id) + $qty;
		if ($real_qty < 2) {
			debug(array('item_id', 'user_id', 'quantity'));
			return $this->db->insert('cart', array('item_id' => $item_id, 'user_id' =>  $this->user_id, 'quantity' => $qty));

		} else {
			return $this->db->update('cart', array('quantity' => $real_qty), ' item_id = ? and user_id = ?', array($item_id, $this->user_id));
		}
	}
	
	function addCart($items, $qty = 1){
		if ($items) {
			if (is_array($items)) {
				foreach ($items as $item => $v) {
					if (!$this->_addCart($v, $qty)) return false;
				}
				return true;
			} else if (is_numeric($items)) {
				return $this->_addCart($items, $qty);
			}
		}
	}

	function setUser($id) {
		$this->user_id = $id;
	}
	function getUser() {
		return $this->user_id;
	}
}