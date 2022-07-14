<?php
define('SITE_ROOT',  $_SERVER['DOCUMENT_ROOT']);
$path = "/images/catalog/";
$localpath = $_SERVER['DOCUMENT_ROOT'] . $path;

$sizes = array(
	'50x50',
	'100x100',
	'150x150',
	'200x200',
	'250x250',
	'300x300',
	'600x450'
);
require_once "_init.php";
// ensure there was a thumb in the URL

if (!$_GET['params']) { error('no thumb'); }

$params = strip_tags(htmlspecialchars($_GET['params']));

$params = explode("/", $_SERVER['REQUEST_URI']);

if (count($params) == 4) {
	// direct to image
	$filename = $params[3];
} else {
	// with size ect..
	list($width, $height) = explode('x', $params[3]);
	$filename = $params[4];
}

//$router = new router('catalog/mod/size/id');

//list($width, $height) = explode('x', $router->size);
//$id = $router->id;

// ensure the size is valid
if (!in_array($params[3], $sizes)) {	error('invalid size');}
// make the directory to put the image

// make the directory to put the image
if (!mkpath((dirname($localpath . $params[3] . '/' . $filename)), true)) { error('cannot create directory');}



/*if ($router->mod == 'catalog') {
	if (is_numeric($id)) {
		$catalog = new catalog();
		list($filename) = $catalog->getItemImageFile($id);
	} else {
		$filename = $id;
	}
} else {

}
*/

// ensure the image file exists
if (!file_exists( $localpath . $filename)) { error('no source image'); }

require_once '_libs/PHPThumbnailer/ThumbLib.inc.php';

try {
	$thumb = PhpThumbFactory::create($_SERVER['DOCUMENT_ROOT'] . '/images/catalog/'. $filename);
	$thumb->resize($width, $height);
	$thumb->save($localpath . $params[3] . '/' . $filename);
} catch (Exception $e) {}


// redirect to the thumb
// note: you need the '?new' or IE wont do a redirect
header('Location: ' . $path . $params[3] . '/' . $filename.'?new');

// basic error handling
function error($error) {
	header("HTTP/1.0 404 Not Found");
	echo '<h1>Not Found</h1>';
	echo '<p>The image you requested could not be found.</p>';
	echo "<p>An error was triggered: <b>$error</b></p>";
	exit();
}

//recursive dir function
function mkpath($path, $mode){
    is_dir(dirname($path)) || mkpath(dirname($path), $mode);
    return is_dir($path) || @mkdir($path,0777,$mode);
}
