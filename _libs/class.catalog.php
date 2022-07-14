<?php

class catalog {
	// @var database;
	private $db;
	public $category_id;

	function  __construct() {
		$this->db = database::getInstance();
	}

	function getItemsTotal() {
		$total =  	$this->db->dcount('item_id', 'catalog_items');
		return $total;
	}

	function getCategories($owner, $filterActiveOnly = false) {
		$activeFilter = ($filterActiveOnly) ? "AND c.active = 1" : "";

		$qO = ($owner) ? "= $owner" : "IS NULL";

		$this->db->query("
			SELECT
				i.image_file,
				i.image_id,
				c.*
			FROM
				catalog_categories c
                LEFT JOIN images i ON (c.category_id = i.item_id AND i.type_id = 1)
			WHERE
				c.category_pid $qO $activeFilter
			ORDER BY
				c.order_id
		");

		return Array('count'=> $this->db->found_rows, 'data' => ($this->db->found_rows) ? $this->db->fetch_assoc_all() : false);

	}

	function getCategoriesNavTree($id) {
		$path = $this->getPath($id);
		foreach ($path as $k => $v) {
			$path[$k]['nodes'] = $this->getCategories($v['category_pid']);
		}

		return $path;
	}

	function getAllCategories(){
		$this->db->query("
			SELECT
			  c.category_id,
			  p.category_title AS parent_category_title,
			  c.category_pid,
			  c.category_title,
			  c.category_alternative_title,
			  p.category_alternative_title AS parent_category_alternative_title
			FROM
			  catalog_categories c
			  LEFT OUTER JOIN catalog_categories p ON (c.category_pid = p.category_id)
			WHERE
			  c.order_level = 2
			ORDER BY
			  p.order_id,
			  c.order_id
		");
		return $this->db->fetch_assoc_all();
		
	}

	function addCategoryFeature($category_id, $feature_id, $marked = "false") {
		$marked = ($marked) ? "true" : "false";
		if ($this->db->insert('catalog_category_features', array('category_id' => $category_id, 'feature_id' => $feature_id, 'marked' =>$marked))) {
			$id = $this->db->insert_id();
			$this->db->update('catalog_category_features', array('feature_order' => $id), "id = $id");
			return true;
		};
		return false;
	}

	function addItemFeature($item_id, $feature_id, $feature_value) {
		if ($this->db->insert('catalog_items_features', array('item_id' => $item_id, 'feature_id' => $feature_id, 'feature_value' => $feature_value))) {
			return $this->db->insert_id();
		} else {
			return false;
		}
	}

	function deleteItemFeature($item_id, $feature_id) {
		return $this->db->delete('catalog_items_features', "item_id = $item_id AND feature_id = $feature_id");
	}

	function deleteItem($item_id) {
		$this->db->delete('catalog_items', "item_id = $item_id");
		$this->db->delete('catalog_items_features', "item_id = $item_id");
		$this->db->delete('catalog_items_reviews', "item_id = $item_id");
		$this->db->delete('images', "item_id = $item_id");
		$this->db->delete('catalog_categories_items', "item_id = ?", array($item_id));
	}

	function deleteItemFeatures($item_id) {
		return $this->db->delete('catalog_items_features', "item_id = ?", array($item_id));
	}

	function cloneItemFeatures($item_id, $from) {
		$query = "
			INSERT INTO catalog_items_features (item_id, feature_id, feature_value)
			SELECT $item_id, feature_id, feature_value FROM catalog_items_features WHERE item_id = $from AND feature_id <> 0";
		return $this->db->query($query);
	}

	function setDefaultItemImage($image_id) {
		$item_id = $this->db->dlookup('item_id', 'images', 'image_id = ?', array($image_id));
		if (!empty($item_id)) {
			$this->db->update('images', array('default_image' => 'false'), 'item_id = ? AND type_id = 2', array($item_id));
			$this->db->update('images', array('default_image' => 'true'), 'image_id = ?', array($image_id));
		}
		return $item_id;
	}

	function defaultCategoryImage($image_id) {
		$item_id = $this->db->dlookup('item_id', 'images', 'image_id = ?', array($image_id));
		if ($item_id) {
			$this->db->update('images', array('default_image' => 'false'), 'item_id = ? AND type_id = 1', array($item_id));
			$this->db->update('images', array('default_image' => 'true'),  'image_id = ?', array($image_id));
		}
		return $item_id;
	}

	function getCategoryFeaturesList() {
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

	function getTopCategories($ids) {
		$query = "
			SELECT t1.category_id,
			(SELECT t2.category_id
				FROM catalog_categories t2
				WHERE t2.order_left < t1.order_left AND t2.order_right > t1.order_right
				ORDER BY t2.order_right - t1.order_right ASC
				LIMIT 1
			) as parent_id,
			(SELECT t2.category_title
				FROM catalog_categories t2
				WHERE t2.order_left < t1.order_left AND t2.order_right > t1.order_right
				ORDER BY t2.order_right - t1.order_right ASC
				LIMIT 1
			) as parent_title
		FROM catalog_categories t1
		WHERE t1.category_id IN ($ids)
		ORDER BY order_right - order_left DESC";

		$this->db->query($query);
		if ($this->db->returned_rows > 0) {
			return $this->db->fetch_assoc_all();
		}
	}

	function toggleCommissionItem($id) {
		$query = "
			UPDATE catalog_items i
			SET i.commission = 1 - i.commission
			WHERE i.item_id = $id
   		";
		return $this->db->query($query);
	}

	function getAllCommissionItems() {
		$query = "
			SELECT
			  i.*,
			  img.image_file,
			  c.category_id
			FROM
			  catalog_items i
			  LEFT OUTER JOIN images img ON (img.item_id = i.item_id AND img.type_id = 2 AND img.default_image = 'true')
			  LEFT OUTER JOIN catalog_categories_items c ON (c.item_id = i.item_id)
			WHERE i.active = 1 AND i.commission = 1
			ORDER BY c.category_id, i.order_id
   		";
		$this->db->query($query);
		$r = array();
		if ($this->db->returned_rows > 0) {
			$res =  $this->db->fetch_assoc_all();
			foreach ($res as $row)  $c[] = $row['category_id'];
			$categories = $this->getTopCategories(implode(',', $c));
			if (is_array($categories)) foreach ($categories as $cat) $newCats[(int)$cat['category_id']] = array('parent_id' => $cat['parent_id'], 'parent_title' => $cat['parent_title']);
			foreach ($res as $k=>$row) {
				$res[$k]['parent_id'] = $newCats[$res[$k]['category_id']]['parent_id'];
				$res[$k]['parent_title'] = $newCats[$res[$k]['category_id']]['parent_title'];
				if (!isset($r[$newCats[$res[$k]['category_id']]['parent_id']])) $r[$newCats[$res[$k]['category_id']]['parent_id']] = array('title' => $newCats[$res[$k]['category_id']]['parent_title']);
				$r[$newCats[$res[$k]['category_id']]['parent_id']]['children'][] = $res[$k];
			}
			return $r;
		}
		return false;
	}


	function getItem($id) {
        $result = $this->db->query("
				SELECT
					i.*
				FROM
					catalog_items i
				WHERE
					i.item_id = $id
			");
		$item = $this->db->fetch_assoc($result);
		$item['features'] = $this->getItemFeatures($id);
        $symbols = array('/\x07/', '/\t/', '/"/', '/\s+/', '/  /');
        $replace = array('', ' ', '\"', ' ', ' ');
        if (isset($item['item_description'])) {
			$item['item_description'] = preg_replace($symbols, $replace, $item['item_description']);
			$item['item_description'] = preg_replace('/[\s]/', " ", $item['item_description']);
			/*$item['item_description_short'] = preg_replace($symbols, $replace, $item['item_description_short']);
			$item['item_description_short'] = preg_replace('/[\s]/', " ", $item['item_description_short']);*/
		}

        $item['images'] = $this->getItemImages($id);
		return $item;
	}

	function setPriceByKey($key, $price) {
		$this->db->update('catalog_items', array('price'=> $price), 'item_key = ?', array($key));
	}

	function setTitleByKey($key, $title) {
		$this->db->update('catalog_items', array('item_title' => $title), 'item_key = ?', array($key));
	}

	function hideItems($ids) {				$this->db->query("update catalog_items set active = 0 where item_id in ($ids)");	}
	function showItems($ids) {				$this->db->query("update catalog_items set active = 1 where item_id in ($ids)");	}
	function setItemsAvailable($ids) {		$this->db->query("update catalog_items set availability = 1 where item_id in ($ids)");	}
	function setItemsUnavailable($ids) {	$this->db->query("update catalog_items set availability = 0 where item_id in ($ids)");	}
	function setItemsTempUnavailable($ids) {$this->db->query("update catalog_items set availability = 2 where item_id in ($ids)");	}
	function setItemsPriceWarn($ids) {		$this->db->query("update catalog_items set price_warn = 1 where item_id in ($ids)");	}
	function setItemsPriceNotWarn($ids) {	$this->db->query("update catalog_items set price_warn = 0 where item_id in ($ids)");	}

	function deleteItems($ids) {
		$this->db->delete("catalog_items", "item_id in ($ids)");
		$this->db->delete('catalog_items_features', "item_id in ($ids)");
		$this->db->delete('catalog_items_reviews', "item_id in ($ids)");
		$this->db->delete('images', "item_id in ($ids)");
		$this->db->delete('catalog_categories_items', "item_id in ($ids)");
	}

	function getItemByKey($key) {
		$result = $this->db->query("SELECT i.* FROM catalog_items i WHERE i.item_key = '$key'");
		return $this->db->fetch_assoc($result);
	}


	function saveItemFeatures($features, $item_id) {
		if (is_array($features)) {
			foreach ($features as $f) {
				$id = preg_replace("/[^0-9]/", '', $f['name']);
				$val = $f['value'];
				//$item_id = $f['value'];
				$this->db->update('catalog_items_features', array('feature_value' => $val), "feature_id = $id AND item_id = $item_id");
			}
			return true;
		}
		return false;
	}

	function getFeaturesArray() {
		$this->db->query("SELECT u.title, u.id, u.unit FROM catalog_features u");
		if (!($this->db->returned_rows > 0)) return false;
		$res = array();
		$f = $this->db->fetch_assoc_all();
		foreach($f as $feature) {
			$res[$feature['id']] = array('feature_title' => $feature['title'], 'feature_unit' => $feature['unit']);
		}
		return $res;
	}


	function getItemsFeatures ($arr){
		$ids = implode(',', $arr);
		$query = "SELECT f.feature_id, f.feature_value, f.item_id FROM catalog_items_features f WHERE f.item_id IN ($ids)";
		$this->db->query($query);
		if (!($this->db->returned_rows > 0)) return false;
		$f = $this->db->fetch_assoc_all();
		return $f;
	}

	function fetchFeatures($arr) {
		$featuresList = $this->getFeaturesArray();
		$itemsFeatures = $this->getItemsFeatures($arr);
		if (!$itemsFeatures) return false;
		$res = array();
		$used_f = array();

		foreach ($arr as $item_id) {
			$res[$item_id] = array();
			foreach ($itemsFeatures as $item) {
				if ($item['item_id'] == $item_id && $item['feature_id'] != 0) {
					$res[$item_id][$item['feature_id']] = $item['feature_value'];
					$used_f[] = (int)$item['feature_id'];
				}
			}
		}

		$used_f = array_unique($used_f);
		sort($used_f);
		foreach ($res as $item_id => $f) {
			foreach ($used_f as $fid) {
				if (isset($res[$item_id][$fid])) continue;
				$res[$item_id][$fid] = '';
			}
			ksort($res[$item_id]);
		}

		return array('list'=> $used_f, 'items' => $res);
	}

	function getItemFeatures($id) {
		$result = $this->db->query("
			SELECT
			  i.feature_value,
			  f.title,
			  f.unit,
			  i.feature_id,
			  i.item_id
			FROM
			  catalog_items_features i
			  LEFT OUTER JOIN catalog_features f ON (f.id = i.feature_id)
			WHERE
			  i.item_id = $id
				AND NOT ISNULL(f.title)
				AND f.title <> ''
				AND NOT ISNULL(i.feature_value)
				AND i.feature_value <> ''
			GROUP BY i.feature_id
			");

		if ($this->db->returned_rows > 0) {
			$data = $this->db->fetch_assoc_all();
			foreach ($data as $i => $val) {
			  $data[$i]['feature_value'] = addslashes($data[$i]['feature_value']);
			}
			return $data;
		} else {
			return false;
		}

	}


	function hasSingleItemImage($item_id) {
		$this->db->query("SELECT image_id FROM images WHERE item_id = $item_id AND type_id = 2");
		return ($this->db->found_rows == 1) ? true : false;
	}

	function hasSingleCategoryImage($item_id) {
		return $this->db->dlookup('image_id', 'images', 'item_id = ? AND item_type = ?' , array($item_id, 'category'));
	}

	function getItemByImage($id) {
		return $this->db->dlookup('item_id', 'images', "image_id = $id AND type_id = 2");
	}

	function deleteItemImage($image_id) {
		if ($image_id) {
			$data = $this->db->dlookup('item_id, image_file', 'images', "image_id = $image_id AND type_id = 2");
			if (!empty($data)) {
				if ($this->db->delete('images', "image_id = $image_id")) {
					@unlink($_SERVER['DOCUMENT_ROOT'] . '/images/catalog/' . $data['image_file']);
					return $data['item_id'];
				}
			}
		}
		return false;
	}

	function deleteCategoryImage ($category_id) {
		$data = $this->db->dlookup('image_id, image_file', 'images', "item_id = $category_id AND type_id = 1");
		if (!empty($data)) {
			if ($this->db->delete('images', "image_id = {$data['image_id']}")) {
				@unlink($_SERVER['DOCUMENT_ROOT'] . '/images/catalog/' . $data['image_file']);
				return true;
			}
		}
		return false;
	}

	function addItemImage($item_id, $imageFileName) {
		$this->db->insert('images', array('item_id' => $item_id, 'image_file' => $imageFileName, 'type_id' => 2));
		$image_id = $this->db->insert_id();
		if ($this->hasSingleItemImage($item_id)) $this->setDefaultItemImage($image_id);
	}

	function addCategoryImage($cid, $imageFileName) {
		$this->db->delete('images', 'item_id = ? AND type_id = 1', array($cid));
		$this->db->insert('images', array('item_id' => $cid, 'image_file' => $imageFileName, 'type_id' => 1));
		$image_id = $this->db->insert_id();
		//if ($this->hasSingleCategoryImage($cid))
		$this->defaultCategoryImage($image_id);
	}

	function getItemImages($id) {
		$this->db->query("
			SELECT
			  i.default_image,
			  i.image_file,
			  i.image_id
			FROM
			  images i
			WHERE i.item_id = $id AND i.type_id = 2
			ORDER BY i.default_image
			");
        return $this->db->fetch_assoc_all();
	}

	function getCategoryImage($id) {
		return $this->db->dlookup('image_file', 'images', 'item_id = ? AND type_id = 1', array($id));
	}

	function getCategoryImages($id) {
		$this->db->query("
			SELECT
			  i.default_image,
			  i.image_file,
			  i.image_id
			FROM
			  images i
			WHERE i.item_id = ? AND i.type_id = 1
			ORDER BY
				i.default_image
			", array($id));
        return $this->db->fetch_assoc_all();
	}

	function reorder($items) {
		foreach ($items as $key => $item) {
			if ($key !='0' && $item != '')
				$this->db->update('catalog_items', array('order_id' => $key), "item_id = $item");
		}
	}

	function sortItems($order, $cid) {
		if ($order == 'title') {
			$this->db->query("
				UPDATE catalog_items i
					INNER JOIN (
						SELECT x.item_id, @num := @num + 1 as nrec FROM (
							SELECT i.*
								FROM catalog_items i
								INNER JOIN catalog_categories_items ic ON (ic.item_id = i.item_id)
								WHERE ic.category_id = $cid
								ORDER BY i.item_title ASC
					) x
					INNER JOIN (SELECT @num := 0) y
				)xxx ON (i.item_id = xxx.item_id)
				SET i.order_id = xxx.nrec
			");

		} elseif ($order == 'articul') {
			$this->db->query("
				UPDATE catalog_items i
					INNER JOIN (
						SELECT x.item_id, @num := @num + 1 as nrec FROM (
							SELECT i.*
								FROM catalog_items i
								INNER JOIN catalog_categories_items ic ON (ic.item_id = i.item_id)
								WHERE ic.category_id = $cid
								ORDER BY i.item_key ASC
					) x
					INNER JOIN (SELECT @num := 0) y
				)xxx ON (i.item_id = xxx.item_id)
				SET i.order_id = xxx.nrec
			");
		}

	}

	function searchItems($query) {
		$this->db->query("
				SELECT
				    i.item_id,
				    i.item_title,
				    i.availability,
				    i.price,
				    cc.category_title,
				    c.category_id,
					img.image_file
				FROM
					catalog_items i
				LEFT JOIN catalog_categories_items c ON (c.item_id = i.item_id)
				LEFT JOIN catalog_categories cc ON (cc.category_id = c.category_id)
				LEFT OUTER JOIN images img ON (img.item_id = i.item_id AND img.type_id = 2 AND img.default_image = 'true')
				WHERE
					i.active = 1 AND
					i.item_title LIKE '%$query%'
					OR i.item_key LIKE '%$query%'
					/* OR i.item_description LIKE '%$query%'*/
				ORDER BY
					c.category_id
			", null, true);

        $res = $this->db->fetch_assoc_all();
        return $res;
	}

	function updateItem($item_id, $item_title, $item_alt_title, $item_key, $item_description, $show_image, $price, $price_warn, $item_unit, $availability, $visibility, $category_id, $item_new = 0, $commission = 0, $arrives_in = 0) {
		$this->db->update('catalog_items',
				array(
					'item_title' => 				$item_title,
					'item_title_alternative' => 	$item_alt_title,
					'item_key' =>					$item_key,
					'item_description' => 			$item_description,
					'show_image' => 				$show_image,
					'price' => 						$price,
					'price_warn' => 				$price_warn,
					'item_unit' => 					$item_unit,
					'availability' => 				$availability,
					'active' => 					$visibility,
					'item_new' => 					$item_new,
					'commission' => 				$commission,
					'arrives_in' =>					$arrives_in
				), 'item_id = ?', 					array($item_id));

		$this->db->update('catalog_categories_items', array('category_id' => $category_id), "item_id = $item_id");
	}

	function insertItem($category_id, $item_title, $item_alt_title, $item_key, $item_description, $show_image, $price, $price_warn, $item_unit, $availability, $visibility, $item_new = 1, $commission = 0, $arrives_in = 0) {
		$this->db->insert('catalog_items',
			array(
				'item_title' => $item_title,
				'item_title_alternative' => $item_alt_title,
				'item_key' => $item_key,
				'item_description' => $item_description,
				'show_image' => $show_image,
				'price' => $price,
				'price_warn' => $price_warn,
				'item_unit' => $item_unit,
				'availability' => $availability,
				'active' => $visibility,
				'item_new' => $item_new,
				'commission' => $commission,
				'arrives_in' => $arrives_in
			));

		$item_id = $this->db->insert_id();
		$this->db->update('catalog_items', array('order_id' => $item_id), "item_id = $item_id");
		$this->db->insert('catalog_categories_items', array('category_id' => $category_id, 'item_id'=> $item_id));
		return $item_id;
	}

	function getItemCategoryId($id) {
		return $this->db->dlookup('category_id', 'catalog_categories_items', 'item_id = ?', array($id));	
	}

	function getItemDefaultImage($id) {
		$result = $this->db->query("
				SELECT
					i.image_file
				FROM
					images i
				WHERE
					i.item_id = $id AND i.default_image = 'true' AND i.type_id = 2
				LIMIT 1
			");
		if ($this->db->returned_rows == 1) {
			$res = $this->db->fetch_assoc($result);
			return $res['image_file'];
		} else {
			return false;
		}
	}

	function getCategoryDefaultImage($id) {
		$result = $this->db->query("
				SELECT
					i.image_file
				FROM
					images i
				WHERE
					i.item_id = $id AND i.default_image = 'true' AND i.type_id = 1
				LIMIT 1
			");
		if ($this->db->returned_rows == 1) {
			$res = $this->db->fetch_assoc($result);
			return $res['image_file'];
		} else {
			return false;
		}
	}

	function emptyItemKeywords($id = 0) {
		if ($id) return $this->db->delete('catalog_items_keywords', "item_id = $id");
	}

	function emptyCategoryKeywords($id = 0) {
		if ($id) return $this->db->delete('catalog_category_keywords', "category_id = $id");
	}


	function addKeyword($keyword) {
		if ($this->db->insert('keywords', array('keyword' => $keyword)))
			return $this->db->insert_id();
		else
			return false;
	}

	function getItemKeywords($id, $query = '') {
		$q = "
				SELECT
					k.keyword,
					k.id,
					ik.item_id
				FROM
					catalog_items_keywords ik
					LEFT JOIN keywords as k ON (ik.keyword_id = k.id)
				WHERE
					ik.item_id = $id " . ((!empty($query)) ? " AND k.keyword LIKE '%$query%'" : "");
		$this->db->query($q);
		return $this->db->fetch_assoc_all();
	}

	function getCategoryKeywords ($id, $query = '') {
		if ($query == '') {
			$result = $this->db->query("
				SELECT
					k.keyword,
					k.id,
					ck.category_id
				FROM
					catalog_category_keywords ck
					LEFT JOIN keywords as k ON (ck.keyword_id = k.id)
				WHERE
					ck.category_id = $id
			");
		} else  {
			$this->db->query("
				SELECT
					k.keyword,
					k.id,
					ck.category_id
				FROM
					catalog_category_keywords ck
					LEFT JOIN keywords as k ON (ck.keyword_id = k.id)
				WHERE
					ck.category_id = $id AND k.keyword LIKE '%$query%'
			");

		}
		return $this->db->fetch_assoc_all();
	}

	function setKeyword($keyword) {
		$id = $this->getKeywordId($keyword);
		return ($id) ? (int)$id : $this->addKeyword($keyword);
	}

	function addItemKeyword($item_id, $keyword) {
		$keyword_id = $this->setKeyword($keyword);
		return $this->db->insert('catalog_items_keywords', array('item_id'=> (int)$item_id, 'keyword_id' => $keyword_id));
	}

	function getKeywordId($keyword) {
		$keyword = mb_strtolower($keyword, mb_detect_encoding($keyword));
		$id = $this->db->dlookup('id', 'keywords', 'keyword = ?', array($keyword));
		return $id;
	}

	function checkCategoryKeywordId($id, $kid) {
		return $this->db->dlookup('id', 'catalog_category_keywords', 'category_id = ? AND keyword_id = ?', array($id, $kid));
	}

	function deleteCategoryKeyword ($id, $keyword) {
		$keyword = mb_strtolower($keyword, mb_detect_encoding($keyword));
		$keyword_id = $this->getKeywordId($keyword);
		$this->db->delete('catalog_category_keywords', 'category_id = ? AND keyword_id = ?', array($id, $keyword_id));
	}

	function getKeywordsList($s = '') {
		$queryWhere = ($s == '') ? "" : "WHERE k.keyword LIKE '%$s%'";
		$this->db->query("SELECT k.keyword, k.id FROM keywords as k $queryWhere");
		return $this->db->fetch_assoc_all();
	}

	function addCategoryKeyword ($id, $keyword) {
		$keyword = mb_strtolower($keyword, mb_detect_encoding($keyword));
		$keyword_id = $this->setKeyword($keyword);
		return $this->db->insert('catalog_category_keywords', array('category_id' => $id, 'keyword_id' => $keyword_id));
	}

	function getPath($id) {
		if ($id != '') {
			$result = $this->db->query("
	   		SELECT
	   			c.category_title,
				c.category_id,
				c.category_pid,
				c.order_level
			FROM
				catalog_categories c
			WHERE
				c.category_id = $id
   		");

			// save the path in this array
			$path = array();
			if ($this->db->found_rows > 0) {
				$row = $this->db->fetch_assoc($result);
				$path[] = $row;
				$path = array_merge($this->getPath($row['category_pid']), $path);
			}

			return $path;
		} else {
			return array();
		}

	}

	function hasSingleChild($cid) {
		$this->db->query("
	   		SELECT count(c.category_id) as cnt
			FROM catalog_categories c
			WHERE c.category_pid = $cid
			GROUP BY c.category_id
   		");
		return ((int)$this->db->found_rows == 1);
	}

	function getCategoryInfo($id) {
		$this->db->query("
	   		SELECT
				i.image_file,
				i.image_id,
				c.*
			FROM
				catalog_categories c
                LEFT JOIN images i ON (c.category_id = i.item_id AND i.type_id = 1)
			WHERE
				c.category_id = $id
   		");

		if ($this->db->found_rows > 0) {
			$category = $this->db->fetch_assoc();
			if ($category['is_leaf'] == 'true') {
				$category['single_child'] = $this->hasSingleChild($category['category_pid']);
			}
			return $category;
		} else {
			return false;
		}

	}

	function updateCategory($id, $title, $atitle, $description, $showImage = 'false', $category_view = 'icons', $active = 1){
		return $this->db->update('catalog_categories',
			array('category_title' => $title, 'category_alternative_title' => $atitle, 'category_description' => $description, 'show_image' => $showImage, 'category_view' => $category_view, 'active' => $active),
			"category_id = $id");
	}
	
	function addCategory($pid, $title, $alt_title, $description, $active){
		$lft = $this->db->dlookup('max(order_left)', 'catalog_categories', "category_pid" . ($pid == null) ? "IS NULL" : "= $pid");

		$this->db->query("UPDATE catalog_categories SET order_right = order_right + 2 WHERE order_right  > $lft");
		$this->db->query("UPDATE catalog_categories SET order_left = order_left + 2 WHERE order_left > $lft");
		$this->db->query("UPDATE catalog_categories SET is_leaf = 'false' WHERE category_id = $pid");

		$this->db->insert('catalog_categories',
			array(
				'category_title' => $title,
				'category_alternative_title' => $alt_title,
				'category_description' => $description,
				'category_pid' => $pid,
				'active' => $active,
				'order_left' => $lft + 1,
				'order_right' => $lft + 2,
				'is_leaf' => "true"
			)
		);

		//$this->rebuildCategoryTree(0, 1, -1);

		return $this->db->insert_id();

	}

	
	function deleteCategoryFeature($cid, $feature_id) {
		return $this->db->delete('catalog_category_features', 'category_id = ? AND feature_id = ?', array($cid, $feature_id));
	}
	
	function toggleCategoryFeatureMark($id, $feature_id) {
		$val = $this->db->dlookup('marked', 'catalog_category_features', 'category_id = ? AND id = ?', array($id, $feature_id));
		$res = ($val == 'true') ? 'false' : 'true';
		$this->db->update('catalog_category_features', array('marked' => $res), 'category_id = ? AND id = ?', array($id, $feature_id));
	}
	
	function getCategoryFeatures($id){
		$this->db->query("
	   		SELECT
				cf.id,
				cf.category_id,
	   			cf.feature_id,
				cf.marked,
				f.feature_title,
				f.feature_unit
			FROM
				catalog_category_features cf
			LEFT JOIN
				catalog_features f ON (cf.feature_id = f.feature_id)
			WHERE
				cf.category_id = $id
   		");
		return $this->db->fetch_assoc_all();
	}

	function getCategoryFeaturesId($cid){
		$this->db->query("
			select
				cf.feature_id
			from
				catalog_category_features cf
			WHERE
				cf.category_id = $cid
		", null, true);
		return $this->db->fetch_assoc_all();
	}
	
	/*
	function getItemFeatures($id = 0){
		$this->db->query("
	   		SELECT
				cf.id,
				cf.category_id,
	   			cf.feature_id,
				cf.marked,
				f.feature_title,
				f.feature_unit
			FROM
				catalog_category_features cf
			LEFT JOIN
				catalog_features f ON (cf.feature_id = f.feature_id)
			WHERE
				cf.category_id = $id
   		");
		return $this->db->fetch_assoc_all();
	}
	
*/
	function deleteCategory($id) {
		$pid = $this->db->dlookup('category_pid', 'catalog_categories', "category_id = $id");
		$this->db->delete('catalog_categories', "category_id = $id");
		//$this->rebuildCategoryTree(0, 1, -1);
		$this->reallocateLeafs();
		return $pid;
	}

	function moveItems($old, $new) {
		$this->db->update('catalog_categories_items', array('category_id' => $new), 'category_id = ?', array($old));
	}

	function isLeafCategory($id) {
		//return ($this->db->dlookup('is_leaf', 'catalog_categories', "category_id = $id AND is_leaf = 'true'"));
		return ($this->db->dlookup('is_leaf', 'catalog_categories', "category_id = $id") == 'true');
	}

	function purgeCategoryTreeNodes() {
		$this->db->query("select c1.category_id from catalog_categories c1 left join catalog_categories c2 ON c1.category_pid = c2.category_id where ISNULL(c2.category_id ) AND  c1.category_pid <> 0");
		$ids = $this->db->fetch_assoc_all();
		$array = array();
		foreach ($ids as $id) $array[] = $id['category_id'];
		$arrayStr = implode(',', $array);
		$this->db->query("delete from catalog_categories where category_id in ($arrayStr)");
	}

	function getItemImageFile($id) {
		$this->db->query("
			SELECT
				i.image_file
			FROM
				images i
			WHERE
				i.item_id = $id AND i.type_id = 2
			LIMIT 1
		");

		if ($this->db->returned_rows == 1) {
			$res = $this->db->fetch_assoc();
			return $res['image_file'];
		}  else {
			return false;
		}
	}

	function getImageFile($id) {
		$this->db->query("
			SELECT
				i.image_file
			FROM
				images i
			WHERE
				i.image_id = $id AND i.type_id = 2
			LIMIT 1
		");

		if ($this->db->returned_rows == 1) {
			$res = $this->db->fetch_assoc();
			return $res['image_file'];
		}  else {
			return false;
		}
	}


	function deleteNewItem($id) {
		$this->db->update('catalog_items', array('item_new' => 0), 'item_id = ?', array($id));
	}


	function getNewItems($cid = 0) {

		if ($cid == 0){
			$this->db->query("
				SELECT * FROM catalog_items i
				WHERE i.deleted = 0 AND item_new = 1
				ORDER BY i.order_id
			");
		} else {

			$list = implode(',', $this->getLeafCategoriesList($cid));
			$q = "
				SELECT i.*, img.image_file
				FROM
					catalog_items i
					RIGHT OUTER JOIN catalog_categories_items c ON (c.item_id = i.item_id)
					RIGHT OUTER JOIN images img ON (img.item_id = i.item_id)
				WHERE
					c.category_id IN ($list) AND
					i.deleted = 0 AND i.item_new = 1 AND
					img.default_image = 'true'
				GROUP BY i.item_id
				ORDER BY i.order_id
			";
			$this->db->query($q);
		}

		return ($this->db->found_rows > 0) ? $this->db->fetch_assoc_all() : false;
	}


	function getItemsByCategory($cid, $active = true) {
		$qa = ($active) ? " AND i.active = 1" : "";
		$query = "
	   		SELECT
			  i.*,
			  img.image_file
			FROM
			  catalog_items i
			  LEFT OUTER JOIN images img ON (img.item_id = i.item_id AND img.type_id = 2 AND img.default_image = 'true')
			  LEFT OUTER JOIN catalog_categories_items c ON (c.item_id = i.item_id)
			WHERE
				c.category_id = $cid
				$qa
			GROUP BY i.item_id
			ORDER BY i.order_id
   		";

		$this->db->query($query);

		if ($this->db->returned_rows) {
			$items = $this->db->fetch_assoc_all();
		} else {
			return false;
		}

		$this->db->query("SELECT feature_id FROM catalog_category_features WHERE  category_id = ?", array($cid));

		if ($this->db->found_rows) {
			$feature_ids = $this->db->fetch_assoc_all();

			$ids = array();
			foreach ($feature_ids as $row) {
				$ids[] = $row['feature_id'];
			}

			$feature_list = implode(',', $ids);

			$features_res = $this->db->query("
				SELECT
				  i.feature_value,
				  f.title,
				  f.unit,
				  i.feature_id,
				  i.item_id
				FROM
				  catalog_items_features i
				  LEFT OUTER JOIN catalog_features f ON (f.id = i.feature_id)
				WHERE
				  i.feature_id IN ($feature_list)
			");

			if ($this->db->found_rows) {
				$features_all = $this->db->fetch_assoc_all('id', $features_res);
				foreach ($features_all as $feature) {
					$feature['feature_value'] = addslashes($feature['feature_value']);
					$fa[$feature['item_id']][] = array('feature_title' => $feature['title'], 'feature_value' => $feature['feature_value'], 'feature_unit' => $feature['unit']);
				}

				if (count($items)) {
					for($i = 0; $i < count($items); $i++) {
						if (isset($fa[$items[$i]['item_id']])) $items[$i]['features'] = $fa[$items[$i]['item_id']];
					}
				}

			}

		}

		return $items;
	}

	function getCategoriesWOImages($skip = 0, $limit = 10){
		$this->db->query("
			SELECT DISTINCT
				c.category_id,
    			c.category_title
			FROM  catalog_categories c
			WHERE NOT EXISTS (
				SELECT 1
    			FROM images i
    			WHERE i.item_id = c.category_id AND i.type_id = 1
    		)
			LIMIT $skip, $limit
   		");
		return ($this->db->found_rows > 0) ? $this->db->fetch_assoc_all() : false;
	}

	function getItemsWOImages($skip = 0, $limit = 10){
		$q = "
			SELECT DISTINCT
				c.item_id,
				cc.category_id,
    			c.item_title
			FROM  catalog_items c
			LEFT JOIN catalog_categories_items cc ON (cc.item_id = c.item_id)
			WHERE NOT EXISTS (
				SELECT 1
    			FROM images i
    			WHERE i.item_id = c.item_id AND i.type_id = 2
    		)
			LIMIT $skip, $limit
   		";
		$this->db->query($q);
		return ($this->db->found_rows > 0) ? $this->db->fetch_assoc_all() : false;
	}

	function getItemsArray($arr) {
		$items = implode(',', $arr);
		$query = "
	   		SELECT
				im.image_file,
				im.image_id,
				i.item_title,
				i.item_id,
				i.item_key,
				i.item_unit,
				i.price
			FROM
				catalog_items i
				LEFT JOIN images im ON (i.item_id = im.item_id AND im.type_id = 2 AND im.default_image = 'true')
			WHERE
				i.item_id IN ($items)
			ORDER BY
			  FIELD(i.item_id, $items)
   		";
		$this->db->query($query);
		return $this->db->fetch_assoc_all();
	}

	function getItemsSEO() {
		$this->db->query("
	   		SELECT
				i.item_title,
				i.item_id
			FROM
				catalog_items i
			WHERE i.active = 1
   		");
		return $this->db->fetch_assoc_all();
	}

	function getCategoriesSEO() {
		$this->db->query("
				SELECT
					c.category_id,
					c.is_leaf,
					c.category_title
				FROM
					catalog_categories c
				WHERE
					c.active = 1
				");
		return $this->db->fetch_assoc_all();
	}



	function reallocateLeafs() {
		$this->db->query("
			SELECT t1.category_id
			FROM catalog_categories AS t1
			LEFT JOIN catalog_categories as t2 ON t1.category_id = t2.category_pid
			WHERE t2.category_id IS NULL
		");
		$a1 = $this->db->fetch_assoc_all();
		$a2 = array();
		foreach ($a1 as $k => $v) $a2[] = (int)$v['category_id'];
		$ids = implode(',', $a2);

		$this->db->query("
			UPDATE catalog_categories
			SET catalog_categories.is_leaf = 'true'
			WHERE catalog_categories.category_id IN ($ids)
		");

	}


	function rebuildCategoryTree($parent = 0, $left = 0, $level = -1) {
		$right = $left + 1;
		$level = $level + 1;

		# 0 = NULL
		$query = sprintf('SELECT category_id FROM catalog_categories WHERE category_pid %s ORDER BY order_id', ($parent == 0) ? "is NULL" : "= $parent");

		$this->db->query($query);
		$row = $this->db->fetch_assoc_all();
		var_dump($row);
		foreach ($row as $string) {
			$right = $this->rebuildCategoryTree($string['category_id'], $right, $level);
		}

		$this->db->update('catalog_categories', array('order_left' => $left, 'order_right' => $right, 'order_level' => $level), "category_id = $parent");
		$level = $level - 1;
		return $right + 1;
	}

	function makeParentChildRelations(&$inArray, &$outArray, $currentParentId = 0) {

		if(!is_array($inArray) || !is_array($outArray)) return;

		foreach($inArray as $key => $tuple) {
			if($tuple['pid'] == $currentParentId) {
				$tuple['children'] = array();
				$this->makeParentChildRelations($inArray, $tuple['children'], $tuple['id']);
				$outArray[] = $tuple;
			}
		}
	}

	function make3DArray($inArray) {
		$newArray = array();
		$this->makeParentChildRelations($inArray, $newArray);
		return $newArray;
	}

	// gets tree from parents node
	function getCategoriesTree($id = 0, $current = 0) {

		if (!empty($id)) {
			$result = $this->db->query('SELECT c.order_left, c.order_right FROM catalog_categories c WHERE category_id = ?', array($id));
		} else {
			$result = $this->db->query('SELECT min(c.order_left) as order_left, max(c.order_right) as order_right FROM catalog_categories c');
		}

		$row = $this->db->fetch_assoc($result);

		$right = array();
		$newarr = array();

		$this->db->query("
				SELECT
					c.category_id,
					c.category_pid,
					c.category_title,
					c.is_leaf,
					c.order_left,
					c.order_level,
					c.order_right
				FROM
					catalog_categories c
				WHERE
					c.order_left BETWEEN ? AND ?
				ORDER BY
					c.order_left ASC
				", array($row['order_left'], $row['order_right']));

		$data = $this->db->fetch_assoc_all();

		if ($data) {
			foreach ($data as $row) {
				if (count($right) > 0) {
					while ( count($right) > 0 && ((int) $right[count($right)-1]) < ((int) $row['order_right'])) {
						array_pop($right);
					}
				}

				if ($current == $row['category_id']) {
					$newarr[]  =  array('key' => $row['category_id'], 'focus' => 'true', 'id' => $row['category_id'], 'pid' => $row['category_pid'],  'folder' => $row['is_leaf'], 'title' => $row['category_title']);
				} else {
					$newarr[]  =  array('key' => $row['category_id'], 'id' => $row['category_id'], 'pid' => $row['category_pid'],  'folder' => $row['is_leaf'], 'title' => $row['category_title']);
				}
				$right[] = (int) $row['order_right'];
		   }
		}
		
		return $this->make3DArray($newarr);
	}

	function getCategoriesFlatTree($id) {
		// retrieve the left and right value of the $root node
		if (!$id) {
			$result = $this->db->query('SELECT c.order_left, c.order_right FROM catalog_categories c WHERE category_id = "'.$id.'";');
		} else {
			$result = $this->db->query('SELECT min(c.order_left) as order_left, max(c.order_right) as order_right FROM catalog_categories c;');
		}
	   	$row = $this->db->fetch_assoc($result);
		// start with an empty $right stack
		$right = array();
		$newarr = array();
		$this->db->query("
				SELECT
					c.category_id,
					c.category_pid,
					c.category_title,
					c.is_leaf,
					c.order_left,
					c.order_level,
					c.order_right
				FROM
					catalog_categories c
				WHERE
					c.order_left BETWEEN ? AND ?
				ORDER BY
					c.order_left ASC
				", array($row['order_left'], $row['order_right']));
		$data = $this->db->fetch_assoc_all();
		if ($data) {
			foreach ($data as $row) {
				if (count($right) > 0) {
					while ( count($right) > 0 && ((int) $right[count($right)-1]) < ((int) $row['order_right'])) {
						array_pop($right);
					}
		       }
		       $newarr[]  =  array('id' => $row['category_id'], 'pid' => $row['category_pid'],  'is_leaf' => $row['is_leaf'], 'category_title' => $row['category_title'], 'order_level' => $row['order_level']);
				$right[] = (int) $row['order_right'];
		   }
		}

		return $newarr;
	}

	function getLeafCategories($id) {
		// retrieve the left and right value of the $root node
		$bquery = ($id != 0) ?
			"SELECT c.order_left, c.order_right FROM catalog_categories c WHERE category_id = $id" :
			"SELECT min(c.order_left) as order_left, max(c.order_right) as order_right FROM catalog_categories c";
		$result = $this->db->query($bquery);
		$row = $this->db->fetch_assoc($result);
		// start with an empty $right stack
		$right = array();
		$newarr = array();
		$this->db->query("
				SELECT
					c.category_id,
					c.category_pid,
					c.category_title,
					c.is_leaf,
					c.order_left,
					c.order_level,
					c.order_right
				FROM
					catalog_categories c
				WHERE
					c.is_leaf = 'true' AND
					c.order_left BETWEEN ? AND ?
				ORDER BY
					c.order_left ASC
				", array($row['order_left'], $row['order_right']));
		$data = $this->db->fetch_assoc_all();
		if ($data) {
			foreach ($data as $row) {
				if (count($right) > 0) {
					while ( count($right) > 0 && ((int) $right[count($right)-1]) < ((int) $row['order_right'])) {
						array_pop($right);
					}
				}
				$newarr[]  =  array('id' => $row['category_id'], 'pid' => $row['category_pid'],  'is_leaf' => $row['is_leaf'], 'category_title' => $row['category_title'], 'order_level' => $row['order_level']);
				$right[] = (int) $row['order_right'];
			}
		}

		return $newarr;
	}

	function getLeafCategoriesList($id) {
		// retrieve the left and right value of the $root node
		$bquery = ($id != 0) ?
			"SELECT c.order_left, c.order_right FROM catalog_categories c WHERE category_id = $id" :
			"SELECT min(c.order_left) as order_left, max(c.order_right) as order_right FROM catalog_categories c";
		$result = $this->db->query($bquery);
		$row = $this->db->fetch_assoc($result);
		// start with an empty $right stack
		$right = array();
		$newarr = array();
		$this->db->query("
				SELECT
					c.category_id,
					c.category_title,
					c.order_right,
					c.order_left
				FROM
					catalog_categories c
				WHERE
					c.is_leaf = 'true' AND
					c.order_left BETWEEN ? AND ?
				ORDER BY
					c.order_left ASC
				", array($row['order_left'], $row['order_right']));
		$data = $this->db->fetch_assoc_all();
		if ($data) {
			foreach ($data as $row) {
				if (count($right) > 0) {
					while ( count($right) > 0 && ((int) $right[count($right)-1]) < ((int) $row['order_right'])) {
						array_pop($right);
					}
				}
				$newarr[]  =  $row['category_id'];
				$right[] = (int) $row['order_right'];
			}
		}

		return $newarr;
	}

	function getLeafCategoriesListByTerm($term, $page = 1, $page_limit = 10) {
		$this->db->query("
				SELECT
					c.category_id,
					c.category_title
				FROM
					catalog_categories c
				WHERE
					c.is_leaf = 'true' AND
					c.category_title like '%{$term}%' OR c.category_alternative_title like '%{$term}%'
				ORDER BY
					c.order_left ASC
				LIMIT {$page}, {$page_limit}
				");
		$data = $this->db->fetch_assoc_all();
		return $data;
	}

	function getCategoriesListByTerm($term, $page = 1, $page_limit = 10) {
		$this->db->query("
				SELECT
					c.category_id,
					c.category_title
				FROM
					catalog_categories c
				WHERE
					c.category_title like '%{$term}%'
				ORDER BY
					c.order_left ASC
				LIMIT {$page}, {$page_limit}
				");
		$data = $this->db->fetch_assoc_all();
		return $data;
	}


	function setItemReview($item_id, $value, $review ,$user_id) {
		return $this->db->insert('catalog_items_reviews', array('item_id' => $item_id, 'rating' => $value, 'review' => $review, 'user_id' => $user_id));
	}

	function getItemRating($id) {
		$this->db->query('SELECT AVG(r.rating) as value FROM catalog_items_reviews r WHERE r.item_id = ? GROUP BY r.item_id', array($id));
		return $this->db->fetch_assoc();
	}

	function getReviews($id = 0, $filter_approved = false, $filter = 0) {
		$approvedCondition = ($filter_approved) ? "AND r.approved = $filter" : "";
		$idCondition = ($id > 0) ? "r.item_id = $id" : "";
		$this->db->query("
			SELECT
				r.review,
				i.item_title,
				r.item_id,
				r.id,
				r.rate_date,
				r.approved,
				r.rating,
				u.login,
				u.name
			FROM catalog_items_reviews r
			LEFT JOIN users as u on r.user_id = u.id
			LEFT JOIN catalog_items as i on i.item_id = r.item_id
			WHERE 1=1 $idCondition $approvedCondition
			GROUP BY r.id
			");
		return ($this->db->found_rows) ? $this->db->fetch_assoc_all() : false;
	}

	function getItemReviews($id, $approved = false) {
		$approvedQuery  = ($approved) ? " AND r.approved = 1" : "";
		$this->db->query("
			SELECT
				r.review,
				r.item_id,
				r.id,
				r.rate_date,
				r.approved,
				r.rating,
				u.login,
				u.name
			FROM catalog_items_reviews r
			LEFT JOIN users as u on r.user_id = u.id
			LEFT JOIN catalog_items as i on i.item_id = r.item_id
			WHERE r.item_id = $id $approvedQuery
			GROUP BY r.id
			");
		return ($this->db->found_rows) ? $this->db->fetch_assoc_all() : false;
	}

	function updateItemFeatures($item_id, $featuresData) {
		$fillArray = array();
		foreach ($featuresData as $feature_id => $feature_value) {
			$fillArray[] = array($item_id, $feature_id, $feature_value);
		}
		$this->db->delete('catalog_items_features', 'item_id = ?', array($item_id));
		$this->db->insert_bulk('catalog_items_features', array('item_id', 'feature_id', 'feature_value'), $fillArray );

	}

	function updateReview($id, $approved = 1, $reviewText = '') {
		if (!empty($reviewText)) {
			return $this->db->update('catalog_items_reviews', array('approved' => $approved, 'review' => $reviewText), "id = $id");
		} else {
			return $this->db->update('catalog_items_reviews', array('approved' => $approved), "id = $id");
		}
	}

	function deleteReview($id) {
		return $this->db->delete('catalog_items_reviews', 'id = ?', array($id));
	}

	function getItemReview($id) {
		$this->db->query("
			SELECT
				r.review,
				i.item_title,
				r.id,
				r.item_id,
				r.rate_date,
				r.rating,
				r.approved,
				u.login,
				u.name
			FROM catalog_items_reviews r
			LEFT JOIN users as u on r.user_id = u.id
			LEFT JOIN catalog_items as i on i.item_id = r.item_id
			WHERE r.id = $id
			");
		return ($this->db->found_rows) ? $this->db->fetch_assoc() : false;
	}

	function getUserRatingItems($id) {
		//$this->db->query('SELECT ')
	}

	function isItemRanked($id, $user_id) {
		return $this->db->dcount('id', 'catalog_items_reviews', 'item_id = ? AND user_id = ?', array($id, $user_id));
	}

	function isItemVisible($id) {
		$x =  $this->db->dcount('item_id', 'catalog_items', "item_id = $id AND active=1");
		return $x;
	}

	function getFeatures() {
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

	function deleteFeature($id) {
		$this->db->delete('catalog_features', 'id = ?', array($id));
	}

	function updateFeature($id, $title, $unit) {
		$this->db->update('catalog_features', array('title'=>$title, 'unit'=>$unit), 'id = ?', array($id));
	}

	function addFeature($title, $unit) {
		$this->db->insert('catalog_features', array('title'=> $title, 'unit'=>$unit), array($title, $unit));
	}

}