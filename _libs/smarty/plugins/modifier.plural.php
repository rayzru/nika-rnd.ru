<?php
/**
 * Smarty  modifier plugin
 *
 * Type:     modifier<br>
 * Example: {$var|plural:'штука':'штуки':'штук'}
 * если $var =1, то выводится штука
 * если $var =2, то выводится штуки
 * если $var =6, то выводится штук
 *  и так для любой числовой переменной и слова(к примеру:литр пива,литра пива,литров пива)
 * вроде подходит и для украинских слов
 * Date:   22 Май , 2009
 * @author   becon 
 * @version  1.0
 * @param string
 * @param string 
 * @return string
 */
function smarty_modifier_plural($count, $form1, $form2, $form3)
 {
		$count = str_replace (' ', '', $count);
		if ($count > 10 && floor(($count % 100) / 10) == 1) {
			return $form3;
		} else {
			switch ($count % 10) {
				case 1: return  $form1;
				case 2:
				case 3:
				case 4: return  $form2;
				default: return  $form3;
			}
		}
}
?>