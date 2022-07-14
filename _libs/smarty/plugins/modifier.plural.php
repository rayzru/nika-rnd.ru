<?php
/**
 * Smarty  modifier plugin
 *
 * Type:     modifier<br>
 * Example: {$var|plural:'�����':'�����':'����'}
 * ���� $var =1, �� ��������� �����
 * ���� $var =2, �� ��������� �����
 * ���� $var =6, �� ��������� ����
 *  � ��� ��� ����� �������� ���������� � �����(� �������:���� ����,����� ����,������ ����)
 * ����� �������� � ��� ���������� ����
 * Date:   22 ��� , 2009
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