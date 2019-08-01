<?php

/**
 * 目录操作类
 *
 *
 *
 *
 */
class DirectoryLib {
	public $curparentdir = ''; //当前目录父级目录
	public $curdir = ''; //当前目录
	public $newdir = ''; //新目录位置
	public $dirauth = '0700'; //权限

	public function __construct($path) {
		if ('' != $path) {
			$this->curparentdir = strtolower($path);
			$this->getParentDir();
		}
	}

	//获取当前目录的上级目录
	public function getParentDir() {
		return strtolower(dirname(dirname($this->curdir)));
	}

	//遍历目录及子目录全部文件
	public function readDir() {
		$result = array();
		if (is_dir($this->curdir)) {
			$handler = opendir($this->curdir);
			while (($file = readdir($handler)) !== false) {
				if ($file == '.' || $file == '..') {
					//忽略当前目录的.和上级目录的..
					continue;
				}

				if (is_file($this->curdir . DIRECTORY_SEPARATOR . $file)) {
					$result[] = $file;
				} elseif (is_dir($folder . DIRECTORY_SEPARATOR . $file)) {
					$this->curdir = $this->curdir . DIRECTORY_SEPARATOR . $file;
					$result[$file] = $this->readDir();
				}
			}

			closedir($handler);
		}
		return $result;
	}

	//创建目录
	public function createDir() {
		if ('' != $this->curdir) {
			if ($this->checkDir()) {
				//已存在
				return true;
			}
			if (!is_writable($this->curparentdir)) {
				//父级目录不可写
				return false;
			}
			return mkdir($this->curdir, $this->dirauth, true);
		}
		return false;
	}

	//删除目录
	public function deleteDir() {
		if (!$this->checkDir) {
			return false; //不存在
		}
		if (!is_writable($this->curparentdir)) {
			//父级目录不可写
			return false;
		}
		return rmdir($this->curdir);
	}

	//移动目录
	public function moveDir() {
		if (!$this->checkDir) {
			return false; //不存在
		}
		if (!is_writable($this->curparentdir)) {
			//父级目录不可写
			return false;
		}
		return rename($this->curdir, strtolower($this->newdir));
	}

	//检测目录是否存在
	public function checkDir() {
		if (!file_exists($this->curdir)) {
			return false;
		}
		return true;
	}

}