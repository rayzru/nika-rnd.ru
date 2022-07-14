<?php
class mailer extends PHPMailer {

	public $mailer;

	function __construct() {
	    $this->mailer = new PHPMailer();
		$this->mailer->isSMTP();
		//$this->mailer->SMTPDebug = 2;
		$this->mailer->Debugoutput = 'html';
		$this->mailer->CharSet = 'UTF-8';
		$this->mailer->Host = SMTP_HOST;
		$this->mailer->Port = SMTP_PORT;
		$this->mailer->SMTPAuth = SMTP_AUTH;
		$this->mailer->Username = SMTP_USER;
		$this->mailer->Password = SMTP_PASS;
		$this->mailer->SMTPSecure = SMTP_SECURE;
		$this->mailer->setFrom(SENDER, "Почтовая служба " . $_SERVER['SERVER_NAME']);
		$this->mailer->isHTML(true);
	}

	function addAddress($adress, $name = '') {
		return $this->mailer->addAddress($adress, $name);
	}

	function setMessage($message) {
		$this->mailer->Body    = $message;
	}

	function setSubject($subject) {
		$this->mailer->Subject = $subject;
	}

	function send() {
		return $this->mailer->send();
	}
	
}