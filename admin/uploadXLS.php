<?php

	set_include_path($_SERVER['DOCUMENT_ROOT']);
	include_once 'admin/_init.php';

/**
 * Handle file uploads via XMLHttpRequest
 */
class qqUploadedFileXhr {
    /**
     * Save the file to the specified path
     * @return boolean TRUE on success
     */
    function save($path) {    
        $input = fopen("php://input", "r");
        $temp = tmpfile();
        $realSize = stream_copy_to_stream($input, $temp);
        fclose($input);
        
        if ($realSize != $this->getSize()){            
            return false;
        }
        
        $target = fopen($path, "w");        
        fseek($temp, 0, SEEK_SET);
        stream_copy_to_stream($temp, $target);
        fclose($target);
        
        return true;
    }
    function getName() {
        return $_GET['qqfile'];
    }
    function getSize() {
        if (isset($_SERVER["CONTENT_LENGTH"])){
            return (int)$_SERVER["CONTENT_LENGTH"];            
        } else {
            throw new Exception('Getting content length is not supported.');
        }      
    }   
}

/**
 * Handle file uploads via regular form post (uses the $_FILES array)
 */
class qqUploadedFileForm {  
    /**
     * Save the file to the specified path
     * @return boolean TRUE on success
     */
    function save($path) {
        if(!move_uploaded_file($_FILES['qqfile']['tmp_name'], $path)){
            return false;
        }
        return true;
    }
    function getName() {
        return $_FILES['qqfile']['name'];
    }
    function getSize() {
        return $_FILES['qqfile']['size'];
    }
}

class qqFileUploader {
    private $allowedExtensions = array();
    private $sizeLimit = 10485760;
    private $file;

    function __construct(array $allowedExtensions = array(), $sizeLimit = 10485760){        
        $allowedExtensions = array_map("strtolower", $allowedExtensions);
            
        $this->allowedExtensions = $allowedExtensions;        
        $this->sizeLimit = $sizeLimit;
        
        $this->checkServerSettings();       

        if (isset($_GET['qqfile'])) {
            $this->file = new qqUploadedFileXhr();
        } elseif (isset($_FILES['qqfile'])) {
            $this->file = new qqUploadedFileForm();
        } else {
            $this->file = false; 
        }
    }
    
    private function checkServerSettings(){        
        $postSize = $this->toBytes(ini_get('post_max_size'));
        $uploadSize = $this->toBytes(ini_get('upload_max_filesize'));        
        
        if ($postSize < $this->sizeLimit || $uploadSize < $this->sizeLimit){
            $size = max(1, $this->sizeLimit / 1024 / 1024) . 'M';             
            die("{'error':'increase post_max_size and upload_max_filesize to $size'}");    
        }        
    }
    
    private function toBytes($str){
        $val = trim($str);
        $last = strtolower($str[strlen($str)-1]);
        switch($last) {
            case 'g': $val *= 1024;
            case 'm': $val *= 1024;
            case 'k': $val *= 1024;        
        }
        return $val;
    }
    
    /**
     * Returns array('success'=>true) or array('error'=>'error message')
     */
    function handleUpload($uploadDirectory, $replaceOldFile = FALSE){
        if (!is_writable($uploadDirectory)){
            return array('error' => "Server error. Upload directory isn't writable.");
        }
        
        if (!$this->file){
            return array('error' => 'No files were uploaded.');
        }
        
        $size = $this->file->getSize();
        
        if ($size == 0) {
            return array('error' => 'File is empty');
        }
        
        if ($size > $this->sizeLimit) {
            return array('error' => 'File is too large');
        }
        
        $pathinfo = pathinfo($this->file->getName());
        //$filename = $pathinfo['filename'];
        $filename = md5(uniqid());
        $ext = $pathinfo['extension'];

        if($this->allowedExtensions && !in_array(strtolower($ext), $this->allowedExtensions)){
            $these = implode(', ', $this->allowedExtensions);
            return array('error' => 'File has an invalid extension, it should be one of '. $these . '.');
        }
        
        if(!$replaceOldFile){
            /// don't overwrite previous files that were uploaded
            while (file_exists($uploadDirectory . $filename . '.' . $ext)) {
                $filename .= rand(10, 99);
            }
        }
        
        if ($this->file->save($uploadDirectory . $filename . '.' . $ext)){

	        return array('success'=>true, 'filename' => $filename . '.' . $ext);

        } else {
            return array('error'=> 'Could not save uploaded file.' .
                'The upload was cancelled, or server error encountered');
        }
        
    }    
}

// list of valid extensions, ex. array("jpeg", "xml", "bmp")
$allowedExtensions = array('xls', 'xlsx');
// max file size in bytes
$sizeLimit = 1 * 1024 * 1024;
$uploader = new qqFileUploader($allowedExtensions, $sizeLimit);
$result = $uploader->handleUpload($_SERVER['DOCUMENT_ROOT'] . '/admin/upload/');

if ($result['success']) {
	$inputFileName = $_SERVER['DOCUMENT_ROOT'] . '/admin/upload/' . $result['filename'];
	$inputFileType = PHPExcel_IOFactory::identify($inputFileName);
	$objReader = PHPExcel_IOFactory::createReader($inputFileType);
	$objXLS = $objReader->load($inputFileName);
	$objWorksheet = $objXLS->getActiveSheet();
	$data = array();
	$k = 0;
	foreach ($objWorksheet->getRowIterator() as $row) {
		$cellIterator = $row->getCellIterator();
		$cellIterator->setIterateOnlyExistingCells(false);
		$status = false;
		foreach ($cellIterator as $i => $cell) {
			if ($i == 0) {
				$val = $cell->getValue();
				if (preg_match('/([a-zA-Z0-9])+/', $val)) {
					$status = true;
				};
			} elseif ($i == 1 && $status) {
				$data[$val] = $cell->getValue();
				if (is_numeric($data[$val])) $k++;
				$status = false;
			}
		}
	}

	if (count($data)/($k-1) > .7) {
		$catalog = new catalog();
		foreach ($data as $key => $price) {
			$item = $catalog->getItemByKey($key);
            if ($item) {
                $item['newprice'] = $price;
                $result['items'][] = $item;
            }
		}
		$result['action'] = 'changePrices';

	} else {
		$catalog = new catalog();
		foreach ($data as $key => $name) {
			$item = $catalog->getItemByKey($key);
			if ($item) {
                $item['newname'] = $name;
                $result['items'][] = $item;
            }
		}

		$result['action'] = 'changeNames';
	}
}

echo htmlspecialchars(json_encode($result), ENT_NOQUOTES);
