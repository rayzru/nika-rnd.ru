<?php
class qa {
	//@var database
	private $db;

	function __construct() {
		$this->db = database::getInstance();
	}

	function add($text, $name, $email, $address = '', $phone = '', $item_id = 0){
	    return $this->db->insert('qa', array('question' => $text, 'name'=>$name, 'email' => $email, 'address' => $address, 'phone' => $phone, 'item_id' => $item_id, 'active' => 1, 'published_date' =>  date("Y-m-d H:i:s")));
	}

	function update($id, $text = '', $answer, $status = 'queued', $active = 1){
		if (!empty($text)) {
			return $this->db->update('qa', array('question' => $text, 'answer' => $answer, 'status' => $status, 'active' => $active), 'id = ?', array($id));
		} else {
			return $this->db->update('qa', array('answer' => $answer, 'status' => $status, 'active' => $active), 'id = ?', array($id));
		}

	}
	function delete($id){
		return $this->db->delete('qa', 'id = ?', array($id));
	}

	function getByItem($id) {
		$this->db->query("
			SELECT
				q.id as id,
				q.name as name,
				q.question as question,
				q.answer as answer,
				q.published_date as published_date,
				q.item_id as item_id,
				i.item_title as item_title
			FROM qa q
				LEFT OUTER JOIN catalog_items i ON (i.item_id = q.item_id)
			WHERE q.item_id = $id AND q.status = 'closed' AND q.active = 1");
		return ($this->db->found_rows > 0) ? $this->db->fetch_assoc_all() : false;
	}

	function getByID($id) {
		$this->db->query("
			SELECT
				q.*,
				i.item_title as item_title
			FROM qa q
				LEFT OUTER JOIN catalog_items i ON (i.item_id = q.item_id)
			WHERE q.id = $id
		");
		if ($this->db->found_rows > 0) {
			return $this->db->fetch_assoc();
		} else return false;

	}

	function setStatus($id, $status = '') {
		if (in_array($status, array('approved', 'suspended', 'deleted','new'))) {
			$this->db->update('qa', array('status'), array($status), 'id = ?', array($id));
		}
	}


	function getQACount() {
		return $this->db->dlookup('count(id)', 'qa');
	}

	function getCount($params = array()) {
		$defaults = array(
			'status' => 'queued',
			'filter_active' => false,
		);

		$params = parse_args($params, $defaults);

		$activeCondition = ($params['filter_active']) ? " AND q.active = 1 " : "";
		$statusCondition = (!empty( $params['status'])) ? ((is_array($params['status'])) ? ("AND q.status IN ('" . implode('\',\'', $params['status']) . "')") : ("AND q.status = '" . $params['status'] . "'")) : "";

		$query = "
			SELECT q.id
			FROM qa q
			LEFT OUTER JOIN catalog_items i ON (i.item_id = q.item_id)
			WHERE 1=1 $activeCondition $statusCondition
			";

		$this->db->query($query);

		return $this->db->found_rows;
	}

	function get($params = array()) {
		$defaults = array(
			'limit' => 0,
			'sort' => 'date',
			'status' => 'queued',
			'filter_active' => false,
			'sort_order' => 'DESC',
			'page' => '1'
		);

		$sort_keys = array(
			'date' => 'q.published_date'
		);

		$params = parse_args($params, $defaults);

		$order = $sort_keys[$params['sort']];

		$activeCondition = ($params['filter_active']) ? " AND q.active = 1 " : "";
		$statusCondition = (!empty( $params['status'])) ? ((is_array($params['status'])) ? ("AND q.status IN ('" . implode('\',\'', $params['status']) . "')") : ("AND q.status = '" . $params['status'] . "'")) : "";
		$limit = ( $params['limit'] > 0 ) ? "LIMIT " . ($params['limit'] * ($params['page'] - 1)) . ',' . $params['limit'] : "";

		$query = "
			SELECT
				q.id,
				q.status,
				q.active,
				q.name,
				q.email,
				q.address,
				q.phone,
				q.question,
				q.answer,
				q.published_date,
				q.item_id,
				i.item_title
			FROM qa q
			LEFT OUTER JOIN catalog_items i ON (i.item_id = q.item_id)
			WHERE 1=1 $activeCondition $statusCondition
			ORDER BY {$order} {$params['sort_order']}
			$limit
			";

		$this->db->query($query, null, false, true);

		return ($this->db->found_rows > 0) ? array('data' => $this->db->fetch_assoc_all(), 'count' => $this->db->found_rows) : false;
	}

}