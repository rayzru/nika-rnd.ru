<?php
/**
 * Smarty plugin
 * @package Smarty
 * @subpackage plugins
 */


/**
 * Smarty transliterate modifier plugin
 *
 * Type:     modifier<br>
 * Name:     cleanurl<br>
 * @param string
 * @return string
 */

function smarty_modifier_cleanurl($string){
	$table = array(
		'"' => '',
		'\'' => ''
			
	);

	$output = str_replace(
		array_keys($table),
		array_values($table),$string
	);

	return $output;
}

