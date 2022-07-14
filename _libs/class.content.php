<?php
	class content {
			/*
			 * @var database
			 */
		private $db;
		
		function __construct() { 
			$this->db = database::getInstance();
		}
		
		function __destruct() {}
		
		function add($params) {

			if (!is_array($params)) {
				return false;
			}

			$defaults = array(
				'content_active' => 1
			);

			$params = array_extend($params, $defaults);

			return $this->db->insert('content', $params);
		}
		
		function update($params) {

			if (!is_array($params)) return false;
			if (!isset($params['content_id']) || $params['content_id'] == '') return false;

			$defaults = array(
				'active' => 1,
				'type' => 'news'
			);

			if ($this->db->update('content', $params, 'content_id = ?' , array($params['content_id']))) {
				return true;
			} else {
				return false;
			}
		}

        function getContentTypes() {
            if ($this->db->query("
				SELECT
					cc.category_id,
					cc.category_title,
					cc.category_type
				FROM
					content_category cc
				ORDER BY
					cc.category_order
			")) {
                return $this->db->fetch_assoc_all();
            } else {
                return false;
            }
        }

        function getContentByType($type = 'news', $filterActive = true) {

			$activeFlag = ($filterActive) ? "AND content_active = 1" : "";
			if ($this->db->query("
				SELECT
					c.content_title,
					c.content_id,
					c.content_type,
					c.content_text,
					c.content_date
				FROM
					content c
				where c.content_type = '$type' $activeFlag
				ORDER BY c.content_date DESC
			")) {
				return $this->db->fetch_assoc_all();
			} else {
				return false;
			}
		}

		function get($id) {
			if ($this->db->query("SELECT * FROM content WHERE content_id = ?", array($id))) {
				$content = $this->db->fetch_assoc();
				return $content;
			} else {
				return false;
			}
		}

		function getById($id) {
			if ($this->db->query("SELECT * FROM content WHERE content_id = ?", array($id))) {
				return  $this->db->fetch_assoc();
			} else {
				return false;
			}
		}

		function getByLabel($label) {
			$query = "SELECT c.content_title, c.content_text FROM content c WHERE c.content_label = '$label'";
			$res = $this->db->query($query);
			if ($res) {
				return $this->db->fetch_obj($res);
			} else {
				return false;
			}
		}
		
		function delete($id) {
			return $this->db->delete('content', "content_id = ?", array($id));
		}
	}
