<?php
/**
 * Features controller class
 *
 * @author RayZ
 */
class directories {
	// @var database;
	private $db;

	function  __construct() {
		$this->db = database::getInstance();
	}

	function get($id = 0) {
		if ($id) {
			$this->db->query("
			SELECT
			  f.id,
			  f.title,
			  f.unit
			FROM
			  catalog_features f
			WHERE
				f.id = ?
			ORDER BY
				f.title
   		    ", array($id));
			return $this->db->fetch_assoc();
		} else {
			$this->db->query("
			SELECT
			  f.id,
			  f.title,
			  f.unit
			FROM
			  catalog_features f
			ORDER BY
				f.title
   		    ");
			return $this->db->fetch_assoc_all();
		}
	}

	function delete($id) {
		return $this->db->delete('catalog_features', 'id = ?', array($id));
	}
	
	function update($id, $title, $unit) {
		return $this->db->update('catalog_features', array('title' => $title, 'unit' => $unit), 'id = ?', array($id));
	}
	
	function add($title, $unit) {
		$this->db->insert('catalog_features', array('title' => $title, 'unit' => $unit));
		return $this->db->insert_id();
	}
	
}