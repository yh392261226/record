<?php
/**
 * 文件类
 *
 *
 */
class FileLib {
	public $filepath = '/tmp'; //文件目录
	public $tmpfilename = ''; //临时文件名称
	public $newfilename = ''; //新文件名称
	public $curfilename = ''; //当前文件名称
	public $allowexts = array(
		'gif',
		'png',
		'jpg',
		'jpeg',
		'bmp',
	); //允许的后缀名数组
	public $allowtypes = array(
		'image/gif',
		'image/jpeg',
		'image/pjpeg',
	); //允许的类型数组
	public $allowsize = 0; //允许的文件大小
	public $curfilesize = 0; //当前文件大小
	public $uploaderror = ''; //上传错误
	public $inputname = 'file'; //form表单的标签名称
	public $___FILES = array(); //多维数组专用

	public $readsize = 4096; //读取大小

	//构造函数
	public function __construct() {

	}

/**--文件上传------------------------------------------------------------------------------**/
	//上传主程序
	public function uploadInit($__FILES, $inputname = '', $method = 'single') {
		if ('' != trim($inputname)) {
			$this->inputname = $inputname;
		}

		if (is_array($__FILES) && !empty($__FILES)) {
			if ($method == 'single') {
				$this->tmpfilename = $__FILES[$this->inputname]['tmp_name'];
				$this->curfilename = $__FILES[$this->inputname]['name'];
				$this->curfiletype = $__FILES[$this->inputname]['type'];
				$this->curfilesize = $__FILES[$this->inputname]['size'];
				$this->uploaderror = $__FILES[$this->inputname]['error'];
			} else //多文件上传
			{
				$this->___FILES = $this->formatFileArr($__FILES);
			}
		}
		return false;
	}

	//格式化多文件上传数组
	public function formatFileArr($__FILES = array()) {
		$result = array();
		if (!empty($__FILES) && trim($this->inputname) != '') {
			$i = 0;
			foreach ($__FILES[$this->inputname]['name'] as $key => $val) {
				$result[$i]['name'] = $val;
				$result[$i]['type'] = $__FILES[$this->inputname]['type'][$key];
				$result[$i]['tmp_name'] = $__FILES[$this->inputname]['tmp_name'][$key];
				$result[$i]['error'] = $__FILES[$this->inputname]['error'][$key];
				$result[$i]['size'] = $__FILES[$this->inputname]['size'][$key];
				$i++;
			}
			unset($key, $val, $__FILES);
		}
		return $result;
	}

	//获取文件后缀名
	public function getFileExt() {
		if ('' != $this->curfilename) {
			$tmparr = explode('.', $this->curfilename);
			return strtolower(end($tmparr));
		}
		return '';
	}

	//验证文件大小
	public function checkFileSize() {
		if ($this->curfilesize <= 0) {
			return false;
		}

		if ($this->allowfilesize <= 0) {
			return false;
		}

		if ($this->allowfilesize >= $this->curfilesize) {
			return true;
		}
		return false;
	}

	//验证文件类型
	public function checkFileType() {
		if (!empty($this->allowtypes)) {
			if (!in_array($this->curfiletype, $this->allowfiletypes)) {
				return false;
			}
			return true;
		}
		return false;
	}

	//验证文件后缀
	public function checkFileExt() {
		if (!empty($this->allowexts)) {
			if (!in_array($this->getFileExt(), $this->allowexts)) {
				return false;
			}
			return true;
		}
		return true;
	}

	//创建新文件名
	public function createNewFileName() {
		$this->newfilename = sprintf('%010d', time() - 946656000) . sprintf('%03d', microtime() * 1000) . sprintf('%04d', mt_rand(0, 9999));
		return $this->newfilename;
	}

	//移动文件
	public function doMoveUpfile() {
		if (!file_exists($this->tmpfilename)) {
			return false;
		}
		return move_uploaded_file($this->tmpfilename, $this->newfilename);
	}

	//删除文件
	public function unlinkFile() {
		if (is_file($this->curfilename) && file_exists($this->curfilename)) {
			return unlink($this->curfilename);
		}
		return false;
	}

/**--文件读取/写入------------------------------------------------------------------------------**/

	//追加内容写入内容
	public function writeFile($data = array()) {
		$result = array();
		if (!empty($data) && is_writable($this->curfilename)) {
			$handler = fopen($this->curfilename, 'w');
			foreach ($data as $key => $val) {
				$result[] = fwrite($handler, $val);
			}
			unset($key, $val);
		}
		return $result;
	}

	//追加内容
	public function appendFile($data) {
		if (empty($data) || !is_writable($this->curfilename)) {
			return false;
		}

		$result = array();
		foreach ($data as $key => $val) {
			$result[] = error_log($val, 3, $this->curfilename);
		}
		unset($key, $val);
		return $result;
	}

	//向文件前追加内容
	public function prependFile($data) {
		if (empty($data) || !is_writable($this->curfilename)) {
			return false;
		}

		$result = array();
		$tmpdata = $finaldata = '';
		$tmpdata = implode('', array_values($data));
		if ('' != $tmpdata) {
			$curdata = $this->readFile();
			if (!empty($curdata)) {
				$finaldata = $tmpdata . implode('', $curdata);
			} else {
				$finaldata = $tmpdata;
			}
			$result = $this->writeFile(array($finaldata));
		}

		return $result;
	}

	//读取文件内容
	public function readFile() {
		$result = '';
		if (!is_readable($this->curfilename)) {
			return $result;
		}

		$handle = fopen($this->curfilename, "r");
		$result = fread($handle, filesize($this->curfilename));
		fclose($handle);
		return $result;
	}

	//逐行读取文件内容并生成数组
	public function readFileByLine() {
		$result = array();
		if (!is_readable($this->curfilename)) {
			return $result;
		}

		$handle = @fopen($this->curfilename, "r");
		if ($handle) {
			while (($buffer = fgets($handle, $this->readsize)) !== false) {
				$result[] = $buffer;
			}
			if (!feof($handle)) {
				return array();
			}
			fclose($handle);
		}

		return $result;
	}
}
