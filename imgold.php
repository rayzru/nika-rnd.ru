<?php
include_once "_init.php";
require_once '_libs/PHPThumbnailer/ThumbLib.inc.php';

if (isset($_GET['original'])) {
	if (isset($_GET['id'])) {
		$catalog = new catalog();
		$image_file = $catalog->getItemImageFile($_GET['id']);
		$img = ($image_file) ? "/images/catalog/" . $image_file : "/images/image_blank.jpg";
		try {
			$thumb = PhpThumbFactory::create($_SERVER['DOCUMENT_ROOT'] . $img);
			$thumb->show();
		} catch (Exception $e) {
			//
		}
	}

	if (isset($_GET['image'])) {
		$catalog = new catalog();
		$image_file = $catalog->getImageFile($_GET['image']);
		$img = ($image_file) ? "/images/catalog/" . $image_file : "/images/image_blank.jpg";

		try {
			$thumb = PhpThumbFactory::create($_SERVER['DOCUMENT_ROOT'] . $img);
			$thumb->show();
		} catch (Exception $e) {
			//

		}
	}

} else {

	$size = (isset($_GET['s']) && (int)$_GET['s'] > 0) ? (int)$_GET['s'] : 100;

	if (isset($_GET['id'])) {
		$catalog = new catalog();
		$image_file = $catalog->getItemImageFile($_GET['id']);
		$img = ($image_file) ? "/images/catalog/" . $image_file : "/images/image_blank.jpg";

		try {
			$thumb = PhpThumbFactory::create($_SERVER['DOCUMENT_ROOT'] . $img);
			$thumb->resize($size, $size);
			$thumb->show();
		} catch (Exception $e) {
			//

		}
	}

	if (isset($_GET['image'])) {
		$catalog = new catalog();
		$image_file = $catalog->getImageFile($_GET['image']);
		$img = ($image_file) ? "/images/catalog/" . $image_file : "/images/image_blank.jpg";

		try {
			$thumb = PhpThumbFactory::create($_SERVER['DOCUMENT_ROOT'] . $img);
			$thumb->resize($size, $size);
			$thumb->show();
		} catch (Exception $e) {
			//

		}
	}
}

?>