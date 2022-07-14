<?php

function getCurrencyRates() {

	$text="";
	$date = date("d/m/Y");
	$link = "http://www.cbr.ru/scripts/XML_daily.asp?date_req=$date";
	$fd = fopen($link, "r");
	if (!$fd) return false;
	else while (!feof ($fd)) $text .= fgets($fd, 4096);
	fclose ($fd);

	$pattern = "#<Valute ID=\"([^\"]+)[^>]+>[^>]+>([^<]+)[^>]+>[^>]+>[^>]+>[^>]+>[^>]+>[^>]+>([^<]+)[^>]+>[^>]+>([^<]+)#i";
	preg_match_all($pattern, $text, $out, PREG_SET_ORDER);

	$dollar = "";
	$euro = "";
	$yua = "";
	$en = "";
	foreach($out as $cur) {
		if($cur[2] == 840) $dollar = str_replace(",",".",$cur[4]);
		if($cur[2] == 978) $euro   = str_replace(",",".",$cur[4]);
		if($cur[2] == 156) $yua   = str_replace(",",".",$cur[4]);
		if($cur[2] == 392) $en   = str_replace(",",".",$cur[4]);
	}

	return array('USD' => $dollar, 'EUR' => $euro);
}

function removeQSVar($url, $varname) {
	list($urlpart, $qspart) = array_pad(explode('?', $url), 2, '');
	parse_str($qspart, $qsvars);
	unset($qsvars[$varname]);
    $newqs = http_build_query($qsvars);
    return $urlpart . '?' . $newqs;
}

function array_extend() {
	$args = func_get_args();
	$extended = array();
	if(is_array($args) && count($args)) {
		foreach($args as $array) {
			if(is_array($array)) {
				$extended = array_merge($extended, $array);
			}
		}
	}
	return $extended;
}


function debug($data) {
	logConsole($data);
}

function getClientIP () {
	if (!empty($_SERVER['HTTP_CLIENT_IP'])) {
		$ip = $_SERVER['HTTP_CLIENT_IP'];
	} elseif (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
		$ip = $_SERVER['HTTP_X_FORWARDED_FOR'];
	} else {
		$ip = $_SERVER['REMOTE_ADDR'];
	}

	$ip = filter_var($ip, FILTER_VALIDATE_IP);
	$ip = ($ip === false) ? '0.0.0.0' : $ip;
	return $ip;
}


/**
 * Logs messages/variables/data to browser console from within php
 *
 * @param $name: message to be shown for optional data/vars
 * @param $data: variable (scalar/mixed) arrays/objects, etc to be logged
 * @param $jsEval: whether to apply JS eval() to arrays/objects
 *
 * @return none
 * @author Sarfraz
 */
function logConsole($data = NULL, $jsEval = TRUE) {
	//if (! $name) return false;

	$isevaled = false;
	$type = ($data || gettype($data)) ? 'Type: ' . gettype($data) : '';

	if ($jsEval && (is_array($data) || is_object($data))) {
		$data = 'eval(' . preg_replace('#[\s\r\n\t\0\x0B]+#', '', json_encode($data)) . ')';
		$isevaled = true;
	} else {
		$data = json_encode($data);
	}

	# sanitalize
	$data = $data ? $data : '';
	$search_array = array("#'#", '#""#', "#''#", "#\n#", "#\r\n#");
	$replace_array = array('"', '', '', '\\n', '\\n');
	$data = preg_replace($search_array,  $replace_array, $data);
	$data = ltrim(rtrim($data, '"'), '"');
	$data = $isevaled ? $data : ($data[0] === "'") ? $data : "'" . $data . "'";

	$js = <<<JSCODE
<script>
     // fallback - to deal with IE (or browsers that don't have console)
     if (! window.console) console = {};
     console.log = console.log || function(name, data){};
     // end of fallback

     // console.log('$name');
     console.log('------------------------------------------');
     console.log('$type');
     console.log($data);
     console.log('\\n');
</script>
JSCODE;
	echo $js;
}

function bindArrayToObject($array) {
	$return = new stdClass();
	foreach ($array as $k => $v) {
		if (is_array($v)) {
			$return->$k = bindArrayToObject($v);
		} else {
			$return->$k = $v;
		}
	}
	return $return;
}

function trim_array(array $array,$int){
	$newArray = array();
	for($i=0; $i<$int; $i++){
		array_push($newArray,$array[$i]);
	}
	return (array)$newArray;
}

function validatePhone($string) {
	$numbersOnly = preg_replace("/[^0-9]/i", "", $string);
	$numberOfDigits = strlen($numbersOnly);
	if ($numberOfDigits == 11) {
		return true;
	} else {
		return false;
	}
}


function parse_args( $args, $defaults = '' ) {
	$r =& $args;
	if ( is_array($defaults)) return array_merge( $defaults, $r );
	return $r;
}

function assign_post_vars($name, $array, &$smarty) {
	$arr = array();
	foreach ($array as $value) if (isset($_POST[$value])) $arr[$value] = $_POST[$value];
	$smarty->assign($name, $arr);
}


function getGreeting() {
	$hourAssign = date("H");
	if (($hourAssign >= 0) && ($hourAssign < 5))
	return "Доброй ночи";
	elseif (($hourAssign >= 10) && ($hourAssign < 18))
	return "Добрый день";
	elseif (($hourAssign >= 18) && ($hourAssign < 24))
	return  "Добрый вечер";
	else
	return "Доброе утро";
}




/**
* Склонение существительных по числовому признаку
*
* @var integer    Число, по которому производится склонение
* @var array    Массив форм существительного
* @return string Существительное в нужной форме
*
* Например:
* $count = 10;
* sprintf('%d %s', $count, declension($count, array('комментарий', 'комментария', 'комментариев')));
*
* Возвращает:
* 10 комментариев
*/
function declension($number, $words) {
    $number = abs($number);
    if ($number > 20) $number %= 10;
    if ($number == 1) return $words[0];
    if ($number >= 2 && $number <= 4) return $words[1];
    return $words[2];
}

/**
* Приводит дату к заданному формату с учетом русских названий месяцев
*
* В качестве параметров функция принимает все допустимые значения функции date(),
* но символ F заменяется на русское название месяца (вне зависимости от локали),
* а символ M — на русское название месяца в родительном падеже
*
* @var integer    Unix-timestamp времени
* @var string    Формат даты согласно спецификации для функции date() с учетом замены значения символов F и M
* @var boolean    Флаг отсекания года, если он совпадает с текущим
* @return string Отформатированная дата
*/
function r_date($time = '', $format = 'j M Y', $cut_year = true) {
    if(empty($time)) $time = time();
    if($cut_year && date('Y') == date('Y', $time)) $format = preg_replace('/o|y|Y/', '', $format);
    $month = abs(date('n', $time)-1);
    $rus = array('января', 'февраля', 'марта', 'апреля', 'мая', 'июня', 'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря');
    $rus2 = array('январь', 'февраль', 'март', 'апрель', 'май', 'июнь', 'июль', 'август', 'сентябрь', 'октябрь', 'ноябрь', 'декабрь');
    $format = preg_replace(array("'M'", "'F'"), array($rus[$month], $rus2[$month]), $format);
    return date($format, $time);
}


/**
* Выводит дату в приблизительном удобочитаемом виде (например, "2 часа и 13 минут назад")
*
* Необходимо наличие функции declension() для корректной работы
*
* @var integer    Unix-timestamp времени
* @var integer    Степень детализации
* @var boolean    Флаг использования упрощенных названий (вчера, позавчера, послезавтра)
* @var string    Формат даты с учетом замены значения символов F и M, если объявлена функция r_date()
* @return string Отформатированная дата
*/
function human_date($timestamp, $granularity = 1, $use_terms = true, $default_format = 'j M Y') {
    $curtime = time();
    $original = $timestamp;
    $output = '';
    if($curtime >= $original) {
        $timestamp = abs($curtime - $original);
        $tense = 'past';
    } else {
        $timestamp = abs($original - $curtime);
        $tense = 'future';
    }
    $units = array('years' => 31536000,
                 'weeks' => 604800,
                 'days' => 86400,
                 'hours' => 3600,
                 'min' => 60,
                 'sec' => 1);
    $titles = array('years' => array('год', 'года', 'лет'),
                 'weeks' => array('неделя', 'недели', 'недель'),
                 'days' => array('день', 'дня', 'дней'),
                 'hours' => array('час', 'часа', 'часов'),
                 'min' => array('минута', 'минуты', 'минут'),
                 'sec' => array('секунда', 'секунды', 'секунд'));
    foreach ($units as $key => $value) {
        if ($timestamp >= $value) {
            $number = floor($timestamp / $value);
            $output .= ($output ? ($granularity == 1 ? ' и ' : ' ') : '') . $number .' '. declension($number, $titles[$key]);
            $timestamp %= $value;
            $granularity--;
        }
    }
    if($tense == 'future') {
        $output = 'Через '.$output;
    } else {
        $output .= ' назад';
    }
  if($use_terms) {
      $terms = array('Через 1 день' => 'Послезавтра',
                     '1 день назад' => 'Вчера',
                     '2 дня назад' => 'Позавчера'
                     );
      if(isset($terms[$output])) $output = $terms[$output];
  }
  return $output ? $output : (function_exists('r_date') ? r_date($original, $default_format) : date($default_format, $original));
}


function generatePassword($length=7, $strength=0) {
	$vowels = 'aeuyo';
	$consonants = 'bdghjmnpqrstvz';
	if ($strength & 1) {
		$consonants .= 'BDGHJLMNPQRSTVWXZ';
	}
	if ($strength & 2) {
		$vowels .= "AEUY";
	}
	if ($strength & 4) {
		$consonants .= '23456789';
	}
	if ($strength & 8) {
		$consonants .= '@#$%';
	}

	$password = '';
	$alt = time() % 2;
	for ($i = 0; $i < $length; $i++) {
		if ($alt == 1) {
			$password .= $consonants[(rand() % strlen($consonants))];
			$alt = 0;
		} else {
			$password .= $vowels[(rand() % strlen($vowels))];
			$alt = 1;
		}
	}
	return $password;
}


function genPassword($syllables = 3, $use_prefix = false) {

    // Define function unless it is already exists
    if (!function_exists('ae_arr')) {
        // This function returns random array element
        function ae_arr(&$arr) {
            return $arr[rand(0, sizeof($arr)-1)];
        }
    }

    // 20 prefixes
    $prefix = array('aero', 'anti', 'auto', 'bi', 'bio',
                    'cine', 'deca', 'demo', 'dyna', 'eco', 'psy',
                    'ergo', 'geo', 'gyno', 'hypo', 'kilo', 'co',
                    'mega', 'tera', 'mini', 'pere', 'nano', 'duo');

    $suffix = array('dom', 'ity', 'ment', 'sion', 'ness',
                    'ence', 'er', 'ist', 'tion', 'or', 'ing', 'est', 'tron', 'es');

    $vowels = array('a', 'o', 'e', 'ei', 'i', 'y', 'u', 'ou', 'oo');

    $consonants = array('w', 'r', 't', 'p', 's', 'd', 'f', 'g', 'h', 'j',
                        'k', 'l', 'z', 'x', 'c', 'v', 'b', 'n', 'm', 'qu');

    $password = $use_prefix?ae_arr($prefix):'';
    $password_suffix = ae_arr($suffix);

    for($i=0; $i<$syllables; $i++) {
        // selecting random consonant
        $doubles = array('n', 'm', 't', 's');
        $c = ae_arr($consonants);
        if (in_array($c, $doubles)&&($i!=0)) { // maybe double it
            if (rand(0, 2) == 1) // 33% probability
                $c .= $c;
        }
        $password .= $c;
        //

        // selecting random vowel
        $password .= ae_arr($vowels);

        if ($i == $syllables - 1) // if suffix begin with vovel
            if (in_array($password_suffix[0], $vowels)) // add one more consonant
                $password .= ae_arr($consonants);

    }

    // selecting random suffix
    $password .= $password_suffix;

    return $password;
}


function UTF8ToEntities ($string) {
    /* note: apply htmlspecialchars if desired /before/ applying this function
    /* Only do the slow convert if there are 8-bit characters */
    /* avoid using 0xA0 (\240) in ereg ranges. RH73 does not like that */
    if (! ereg("[\200-\237]", $string) and ! ereg("[\241-\377]", $string))
        return $string;

    // reject too-short sequences
    $string = preg_replace("/[\302-\375]([\001-\177])/", "&#65533;\\1", $string);
    $string = preg_replace("/[\340-\375].([\001-\177])/", "&#65533;\\1", $string);
    $string = preg_replace("/[\360-\375]..([\001-\177])/", "&#65533;\\1", $string);
    $string = preg_replace("/[\370-\375]...([\001-\177])/", "&#65533;\\1", $string);
    $string = preg_replace("/[\374-\375]....([\001-\177])/", "&#65533;\\1", $string);

    // reject illegal bytes & sequences
    // 2-byte characters in ASCII range
    $string = preg_replace("/[\300-\301]./", "&#65533;", $string);
    // 4-byte illegal codepoints (RFC 3629)
    $string = preg_replace("/\364[\220-\277]../", "&#65533;", $string);
    // 4-byte illegal codepoints (RFC 3629)
    $string = preg_replace("/[\365-\367].../", "&#65533;", $string);
    // 5-byte illegal codepoints (RFC 3629)
    $string = preg_replace("/[\370-\373]..../", "&#65533;", $string);
    // 6-byte illegal codepoints (RFC 3629)
    $string = preg_replace("/[\374-\375]...../", "&#65533;", $string);
    // undefined bytes
    $string = preg_replace("/[\376-\377]/", "&#65533;", $string);

    // reject consecutive start-bytes
    $string = preg_replace("/[\302-\364]{2,}/", "&#65533;", $string);

    // decode four byte unicode characters
    $string = preg_replace(
        "/([\360-\364])([\200-\277])([\200-\277])([\200-\277])/e",
            "'&#'.((ord('\\1')&7)<<18 | (ord('\\2')&63)<<12 |" .
                    " (ord('\\3')&63)<<6 | (ord('\\4')&63)).';'",
        $string);

    // decode three byte unicode characters
    $string = preg_replace("/([\340-\357])([\200-\277])([\200-\277])/e",
        "'&#'.((ord('\\1')&15)<<12 | (ord('\\2')&63)<<6 | (ord('\\3')&63)).';'",
        $string);

    // decode two byte unicode characters
    $string = preg_replace("/([\300-\337])([\200-\277])/e",
        "'&#'.((ord('\\1')&31)<<6 | (ord('\\2')&63)).';'",
        $string);

    // reject leftover continuation bytes
    $string = preg_replace("/[\200-\277]/", "&#65533;", $string);

    return $string;
}

function array_orderby() {
	$args = func_get_args();
	$data = array_shift($args);
	foreach ($args as $n => $field) {
		if (is_string($field)) {
			$tmp = array();
			foreach ($data as $key => $row)
				$tmp[$key] = $row[$field];
			$args[$n] = $tmp;
		}
	}
	$args[] = &$data;
	call_user_func_array('array_multisort', $args);
	return array_pop($args);
}

function mail_utf8($to, $from, $subject = '(No subject)', $message = '', $header = '') {
	$from = ($from == '')? "From: " . strtoupper($_SERVER['SERVER_NAME']) . " <noreply@" . $_SERVER['SERVER_NAME']. ">" . PHP_EOL : 'From: ' . $from . PHP_EOL;
	$header_ = $from . 'MIME-Version: 1.0' . PHP_EOL . 'Content-type: text/plain; charset=UTF-8' . PHP_EOL;
	return mail($to, '=?UTF-8?B?'.base64_encode($subject).'?=', $message, $header_ . $header);
}


function mb_transliterate($string){
	$table = array(
		'А' => 'A', 'Б' => 'B', 'В' => 'V', 'Г' => 'G', 'Д' => 'D',
		'Е' => 'E', 'Ё' => 'YO', 'Ж' => 'ZH', 'З' => 'Z', 'И' => 'I',
		'Й' => 'J', 'К' => 'K', 'Л' => 'L', 'М' => 'M', 'Н' => 'N',
		'О' => 'O', 'П' => 'P', 'Р' => 'R', 'С' => 'S', 'Т' => 'T',
		'У' => 'U', 'Ф' => 'F', 'Х' => 'H', 'Ц' => 'C', 'Ч' => 'CH',
		'Ш' => 'SH', 'Щ' => 'SCH', 'Ь' => '', 'Ы' => 'Y', 'Ъ' => '',
		'Э' => 'E', 'Ю' => 'YU', 'Я' => 'YA',

		'а' => 'a', 'б' => 'b', 'в' => 'v', 'г' => 'g', 'д' => 'd',
		'е' => 'e', 'ё' => 'yo', 'ж' => 'zh', 'з' => 'z', 'и' => 'i',
		'й' => 'j', 'к' => 'k', 'л' => 'l', 'м' => 'm', 'н' => 'n',
		'о' => 'o', 'п' => 'p', 'р' => 'r', 'с' => 's', 'т' => 't',
		'у' => 'u', 'ф' => 'f', 'х' => 'h', 'ц' => 'c', 'ч' => 'ch',
		'ш' => 'sh', 'щ' => 'sch', 'ь' => '', 'ы' => 'y', 'ъ' => '',
		'э' => 'e', 'ю' => 'yu', 'я' => 'ya',
	);

	$output = str_replace(
		array_keys($table),
		array_values($table),$string
	);

	// таеже те символы что неизвестны
	$output = preg_replace('/[^-a-z0-9._\[\]\'"]/i', ' ', $output);
	$output = preg_replace('/ +/', '-', $output);

	return $output;
}

function transliterate($string){
	$table = array(
		'А' => 'A', 'Б' => 'B', 'В' => 'V', 'Г' => 'G', 'Д' => 'D',
		'Е' => 'E', 'Ё' => 'YO', 'Ж' => 'ZH', 'З' => 'Z', 'И' => 'I',
		'Й' => 'J', 'К' => 'K', 'Л' => 'L', 'М' => 'M', 'Н' => 'N',
		'О' => 'O', 'П' => 'P', 'Р' => 'R', 'С' => 'S', 'Т' => 'T',
		'У' => 'U', 'Ф' => 'F', 'Х' => 'H', 'Ц' => 'C', 'Ч' => 'CH',
		'Ш' => 'SH', 'Щ' => 'SCH', 'Ь' => '', 'Ы' => 'Y', 'Ъ' => '',
		'Э' => 'E', 'Ю' => 'YU', 'Я' => 'YA',

		'а' => 'a', 'б' => 'b', 'в' => 'v', 'г' => 'g', 'д' => 'd',
		'е' => 'e', 'ё' => 'yo', 'ж' => 'zh', 'з' => 'z', 'и' => 'i',
		'й' => 'j', 'к' => 'k', 'л' => 'l', 'м' => 'm', 'н' => 'n',
		'о' => 'o', 'п' => 'p', 'р' => 'r', 'с' => 's', 'т' => 't',
		'у' => 'u', 'ф' => 'f', 'х' => 'h', 'ц' => 'c', 'ч' => 'ch',
		'ш' => 'sh', 'щ' => 'sch', 'ь' => '', 'ы' => 'y', 'ъ' => '',
		'э' => 'e', 'ю' => 'yu', 'я' => 'ya',
	);

	$output = str_replace(
		array_keys($table),
		array_values($table),$string
	);

	// таеже те символы что неизвестны
	$output = preg_replace('/\'"]/i', '', $output);
	$output = preg_replace('/[._\[\]]/i', '-', $output);
	$output = preg_replace('/[^-a-z0-9]/i', ' ', $output);
	$output = preg_replace('/ +/', '-', $output);
	$output = trim($output, '-');
	return $output;
}

