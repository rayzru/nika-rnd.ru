<?php
/**
 * Created by JetBrains PhpStorm.
 * User: RayZ
 * Date: 07.02.11
 * Time: 16:24
 * To change this template use File | Settings | File Templates.
 */

class page {
	public $title;
	public $keywords;
	public $description;

	public $scripts;
	public $scriptsCode;
	public $styles;

	function __construct(){
		$this->title = '';
		$this->scripts = array();
		$this->scriptsCode = array();
		$this->styles = array();

		$this->keywords = array();
	}

	public function addScript($url, $script = '', $type = 'text/javascript') {
		if (!empty($url)) $this->scripts[] = array ('url'=> $url, 'type' => $type);
		if (!empty($script)) $this->scriptsCode[] = array ('code' => $script, 'type' => $type);
	}

	public function addCSS($url, $media = 'screen') {
		$this->styles[] = array (
			'url'       => $url,
			'media'     => $media
		);
	}

	public function setTitle($title = '') {
		$this->title = $title;
	}

	public function redirect($url = '/', $code = 301) {
		header("Location: $url", TRUE, $code);
	}

	public function error404() {
		header("Location: /404", TRUE, 404);
		$this->title = 'Ошибка 404: Страница не найдена';
		//exit();
	}

	public function setDescription($description = '') {
		$this->description = $description;
	}

	public function addKeyword($keyword) {
		if (!in_array($keyword, $this->keywords)) {
			$this->keywords[] = $keyword;
			return true;
		} else {
			return false;
		}
	}

	public function addKeywords($keywords) {
		if (empty($keywords)) return false;

		foreach ($keywords as $keyword) {
			if (!in_array($keyword, $this->keywords)) $this->keywords[] = $keyword;
		}

		return true;
	}

	public function clearKeywords() {
		$this->keywords = array();
	}
}