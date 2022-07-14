<?php
class captcha {

	public $operands = array('+', '-');
	public $maxValue = 10;

	function __construct() {
		//if (session_status() == PHP_SESSION_NONE) session_start();
		//$this->operands ;
		if (!isset($_SESSION['captcha'])) $this->set();
	}

	function getOperand() {
		return $this->operands[mt_rand(0, count($this->operands) - 1)];
	}

	function getRandom() {
		return round(mt_rand(1, $this->maxValue));
	}

	function set() {
		$operand = $this->getOperand();
		$firstValue = $this->getRandom();
		do {
			$secondValue = $this->getRandom();
		} while ($operand == '-' && $secondValue > $firstValue);
		$string = $firstValue . $operand . $secondValue;
		$_SESSION['captcha'] = $string;
		return $string;
	}

	function get() {
		return $_SESSION['captcha'];
	}

	function calculate() {
		$string = $this->get();
		if (preg_match('/(\d+)(.?)(\d+)/', $string, $matches)) {
			$matches = $matches;
			$val1 = (int)$matches[1];
			$val2 = (int)$matches[3];
			$res = ($matches[2] == '+') ? $val1+$val2 : $val1-$val2;
			return $res;
		};
		return false;
	}

	/**
	 * destroy captcha info;
	 */
	function __destruct() {
		//@unset($_SESSION['captcha']);
	}
}