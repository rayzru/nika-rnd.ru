<?php
class articles {

	// @var database
	private $db;

	function __construct() {
		$this->db = database::getInstance();
	}

	function delete($id) {
		return $this->db->delete('articles', "id = $id");
	}

	function setKeyword($keyword) {
		$id = $this->getKeywordId($keyword);
		return ($id) ? $id : $this->addKeyword($keyword);
	}

	function addArticleKeyword($item_id, $keyword) {
		$keyword_id = $this->setKeyword($keyword);
		return $this->db->insert('articles_keywords', array('article_id'=> $item_id, 'keyword_id' => $keyword_id));
	}


	function getKeywordId($keyword) {
		$keyword = mb_strtolower($keyword);
		$id = $this->db->dlookup('id', 'keywords', 'keyword = ?', array($keyword));
		return $id;
	}


	function addKeyword($keyword) {
		if ($this->db->insert('keywords', array('keyword' => $keyword)))
			return $this->db->insert_id();
		else
			return false;
	}

	function getArticleKeywords($id, $query = '') {
		$q = "
				SELECT
					k.keyword,
					k.id,
					ik.article_id
				FROM
					articles_keywords ik
					LEFT JOIN keywords as k ON (ik.keyword_id = k.id)
				WHERE
					ik.article_id = $id " . ((!empty($query)) ? " AND k.keyword LIKE '%$query%'" : "");
		$this->db->query($q);
		return $this->db->fetch_assoc_all();
	}

	function getKeywords($query = '') {
		$q = "
				SELECT
					k.keyword,
					k.id
				FROM
					keywords k
				WHERE
					" . ((!empty($query)) ? "k.keyword LIKE '%$query%'" : "");
		$this->db->query($q);
		return $this->db->fetch_assoc_all();
	}

	function emptyArticleKeywords($id = 0) {
		if ($id) return $this->db->delete('articles_keywords', "article_id = $id");
	}


	function assocCategories($categories) {
		$return = array();
		foreach ($categories as $category) {
			$return[$category['category_id']] = $category['category_title'];
		}
		return $return;
	}

	function add($title, $text, $category_id){
		$this->db->insert('articles', array('article_title' => $title, 'article_text' => $text, 'category_id' => $category_id, 'article_date' => date("Y-m-d H:i:s")));
		return $this->db->insert_id();
	}

	function update($id, $title, $text, $category_id){
		return $this->db->update('articles', array('article_title' => $title, 'article_text' =>$text, 'category_id' => $category_id),  'id = ?', array($id));
	}

	function getList($params = array()) {
		$defaults = array(
			'limit' => 0,
			'category' => -1,
			'sort' => 'date',
			'filter_active' => false,
			'sort_order' => 'DESC'
		);

		$sort_keys = array(
			'date' => 'a.article_date'
		);


		$params = parse_args($params, $defaults);

		$order = $sort_keys[$params['sort']];
		$limit = ( $params['limit'] > 0 ) ? "LIMIT " . $params['limit'] : "";
		$category_condition = ($params['category'] != -1) ? " AND a.category_id = " . $params['category'] : "";
		$activity = ($params['filter_active']) ? " AND a.active = 1 " : "";

		$query = "
			SELECT
				a.id,
				a.article_title,
				a.article_date
			FROM articles a
			WHERE 1=1
				$activity
				$category_condition
			ORDER BY {$order} {$params['sort_order']}
			$limit
		";
		$this->db->query($query);

		return ($this->db->found_rows > 0) ? $this->db->fetch_assoc_all() : false;
	}

	function getArticlesSEO() {
		$this->db->query("
			SELECT
				a.id,
				a.article_title
			FROM articles a
			WHERE
				a.active = 1
		");
		return ($this->db->found_rows > 0) ? $this->db->fetch_assoc_all() : false;
	}

	function getCategories(){

		$this->db->select('category_id', 'articles');
		$c = $this->db->fetch_assoc_all();

		if ($this->db->found_rows > 0) {
			foreach ($c as $k => $v) $categories[] =  $v['category_id'];
			$categories = implode(',', array_unique($categories));

			$this->db->query("
			SELECT
			  c.category_id,
			  c.category_pid,
			  c.category_title
			FROM
			  catalog_categories c
			WHERE
			  c.category_id IN ($categories)
			ORDER BY
			  c.order_id
			");
			return ($this->db->found_rows > 0) ? $this->db->fetch_assoc_all() : false;
		} else {
			return false;
		}

	}

	function getArticle($id){
		$this->db->query("
			SELECT a.*
			FROM articles a
			WHERE a.id = $id
		");

		return ($this->db->found_rows > 0) ? $this->db->fetch_assoc() : false;
	}

	function getGroupedContent() {
		$categories = $this->getCategories();
		if ($categories) {
			foreach ($categories as $i => $category) {
				$categories[$i]['articles_list'] = $this->getList(array('category' => $category['category_id']));
			}
			$i = $i + 1;
		} else {
			$i = 0;
		}

		$categories[$i]['category_title'] = '(вне разделов)';
		$categories[$i]['category_id'] = 0;
		$categories[$i]['category_order'] = 65535;
		$categories[$i]['articles_list'] = $this->getList(array('category' => 0));

		return $categories;
	}



	function __destruct() {}

}
