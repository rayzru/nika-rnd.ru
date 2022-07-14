<?php
class TestController extends Zend_Controller_Action 
{
	private $_listMarkersUl = array(
		0 => '•',
		1 => '-'
	);
	
	private $_listMarkersOl = array(
		0 => '\d+\.',
		1 => '\d+\)',
		2 => '\d+\s+-',
		3 => '\d+\s+–'
	);
	
	private $_listMarkersUlRegExp = '';
	
	private $_listMarkersOlRegExp = '';
	
	private function _setListMarkersUlRegExp() {
		if (count($this->_listMarkersUl) > 0) {
			$this->_listMarkersUlRegExp = '^(' . implode('|', $this->_listMarkersUl) . ')\s+';
		}
	}
	
	private function _setListMarkersOlRegExp() {
		if (count($this->_listMarkersOl) > 0) {
			$this->_listMarkersOlRegExp = '^(' . implode('|', $this->_listMarkersOl) . ')\s+';
		}
	}
	
	function init()
	{
		$this->view->baseUrl = $this->_request->getBaseUrl();
		$this->_setListMarkersUlRegExp();
		$this->_setListMarkersOlRegExp();
	}
	
	private function _getListMarkersUlRegExp() {
		return $this->_listMarkersUlRegExp;
	}
	
	private function _getListMarkersOlRegExp() {
		return $this->_listMarkersOlRegExp;
	}
	/**
	 * Catalog home action
	 * @return mixed
	 */
	function indexAction()
	{
		$gm = new Catalog_Goods();
		$goods = $gm->fetchAll();
		
		foreach ($goods AS $good) {
			if (!is_null($good->good_description)) {
				$str = $good->good_description;
				$htmlStr = "";
				
				$listUlStart = false;
				$listOlStart = false;
				$htmlStr = '';
				$htmlStr = preg_replace('/\n\n/', '\n \n', $htmlStr);
				$prevRow = null;
				
				if (preg_match_all('/.+/', $str, $matches)) {
					foreach ($matches[0] AS $row) {
						if (trim($row)) {
							// Check <ul> list
							if (preg_match('/' . $this->_getListMarkersUlRegExp() . '/', $row)) {
								if (false == $listUlStart && false == $listOlStart) {
									$htmlStr .= "<ul>\n";
									$listUlStart = true;
								} elseif (false == $listUlStart && true == $listOlStart) {
									$htmlStr .= "</ol>\n<ul>\n";
									$listUlStart = true;
									$listOlStart = false;
								}
								
								$row = preg_replace('/' . $this->_getListMarkersUlRegExp() . '/', '', $row);
								$htmlStr .= "\t<li>" . trim($row) . "</li>\n";
								continue;
							}
							
							if (true == $listUlStart) {
								$htmlStr .= "</ul>\n";
								$listUlStart = false;
							}
		
							// Check <ol> list
							if (preg_match('/' . $this->_getListMarkersOlRegExp() . '/', $row)) {
								if (false == $listOlStart && false == $listUlStart) {
									$htmlStr .= "<ol>\n";
									$listOlStart = true;
								} elseif (false == $listOlStart && true == $listUlStart) {
									$htmlStr .= "<ul>\n<ol>\n";
									$listOlStart = true;
									$listUlStart = false;
								}
								
								$row = preg_replace('/' . $this->_getListMarkersOlRegExp() . '/', '', $row);
								$htmlStr .= "\t<li>" . trim($row) . "</li>\n";
								continue;
							}
							
							if (true == $listOlStart) {
								$htmlStr .= "</ol>\n";
								$listOlStart = false;
							}
							
							if ($prevRow == 'newline') {
								$htmlStr .= "<p>" . trim($row) . "</p>\n";
								$prevRow = null;
								continue;
							} else {
								if (preg_match('/.*?<\/p>$/', $htmlStr)) {
									$htmlStr = substr(trim($htmlStr), 0, strlen($htmlStr) - 5);
									$htmlStr .= '<br />' . "\n" . trim($row) . "</p>\n";
									continue;
								} else {
									$htmlStr .= "<p>" . trim($row) . "</p>\n";
									continue;
								}
							}
						} else {
							$prevRow = 'newline';
						}
					}
					
					if ($listUlStart == true) {
						$htmlStr .= '</ul>';
					}
					
					$htmlStr = preg_replace('/\t/', ' ', $htmlStr);
					$htmlStr = preg_replace('/[ ]{2,}/', ' ', $htmlStr);
					$htmlStr = preg_replace('/\s+(\.|\,|\;|\:)/', '$1', $htmlStr);
					$htmlStr = preg_replace('/\s+-\s+/', '&nbsp;&mdash; ', $htmlStr);
					$htmlStr = preg_replace('/\s+–\s+/', '&nbsp;&mdash; ', $htmlStr);
					$htmlStr = preg_replace('/"([\wа-яА-Я]{1})([^"]*)([\wа-яА-Я]{1})"/', '&laquo;$1$2$3&raquo;', $htmlStr);			
					$htmlStr = preg_replace('/“([\wа-яА-Я]{1})([^“”]*)([\wа-яА-Я]{1})”/', '&laquo;$1$2$3&raquo;', $htmlStr);
					$htmlStr = preg_replace("/'([\wа-яА-Я]{1})([^']*)([\wа-яА-Я]{1})'/", '&laquo;$1$2$3&raquo;', $htmlStr);
					$htmlStr = preg_replace("/(\d+)м2/", '$1&nbsp;м<sup>2</sup>', $htmlStr);
					$htmlStr = preg_replace("/(\d+)\s*шт\.?/", '$1&nbsp;шт.', $htmlStr);
					$htmlStr = preg_replace("/(\d+)\s*кг([^\wа-яА-Я]+)/", '$1&nbsp;кг$2', $htmlStr);
					$htmlStr = preg_replace("/(\d+)\s*г([^\wа-яА-Я]+)/", '$1&nbsp;гр$2', $htmlStr);
					$htmlStr = preg_replace("/(\d+)\s*мм([^\wа-яА-Я]+)/", '$1&nbsp;мм$2', $htmlStr);
					$htmlStr = preg_replace("/(\d+)\s*м([^\wа-яА-Я]+)/", '$1&nbsp;м$2', $htmlStr);
					$htmlStr = preg_replace("/(\d+)\s*°\s*C/", '$1&deg;&nbsp;C', $htmlStr);
					$htmlStr = preg_replace("/(\d+)\s*°\s*С/", '$1&deg;&nbsp;C', $htmlStr);
					$htmlStr = preg_replace("/(\d+)\s*кВт([^\wа-яА-Я]+)/", '$1&nbsp;кВт$2', $htmlStr);
					$htmlStr = preg_replace("/(\d+)\s*Вт([^\wа-яА-Я]+)/", '$1&nbsp;Вт$2', $htmlStr);
					$htmlStr = preg_replace("/&#179;/", '<sup>3</sup>', $htmlStr);
					$htmlStr = preg_replace("/\s*$/", '', $htmlStr);
					
					$good->good_description = $htmlStr;
					$good->save();
				}
				
				
			}
		}
		
		die();
	}
}