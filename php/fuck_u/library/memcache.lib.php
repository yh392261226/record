<?php
/**
 * php 操作memcache
 *
 *
 *
 *
 */

Class MemcacheLib extends Memcache {
	private static $handler = null; //memcache链接句柄
	public static $host; //memcache服务器地址
	public static $port; //memcache端口
	public $timeout = 300; //默认超时时间
	public $ptimeout; //长连接超时时间
	public static $pass; //memcache auth密码

	public function __construct($type = '') {
		if ('' == $type) {
			if (false == $this->connection()) {
				die('Can not connect to Memcache server:' . self::$host . ':' . self::$port);
			}
		}
		if ('p' == $type) {
			if (false == $this->pconnection()) {
				die('Can not connect to Memcache server:' . self::$host . ':' . self::$port);
			}
		}
	}

	/**
	 * 链接Memcache句柄
	 */
	public function connection() {
		if (null === self::$handler) {
			$handler = new Memcache();
			self::$handler = $handler->connect(self::$host, self::$port);
		}
		return self::$handler;
	}

	/**
	 * 长链接Memcache句柄
	 */
	public function pconnection() {
		if (null === self::$handler) {
			$handler = new Memcache();
			self::$handler = $handler->pconnect(self::$host, self::$port, $this->ptimeout);
		}
		return self::$handler;
	}

	/**
	 * 获取内容
	 *
	 */
	public function getCache($key) {
		return self::$handler->get($key);
	}

	/**
	 * 新增内容
	 */
	public function addCache($key, $value, $expire = 0) {
		if (0 >= intval($expire)) {
			$expire = $this->timeout;
		}
		return self::$handler->add($key, $value, MEMCACHE_COMPRESSED, $expire);
	}

	/**
	 * 设置内容
	 */
	public function setCache($key, $value, $expire = 0) {
		if (0 >= intval($expire)) {
			$expire = $this->timeout;
		}
		return self::$handler->set($key, $value, MEMCACHE_COMPRESSED, $expire);
	}

	/**
	 * 替换内容
	 */
	public function replaceCache($key, $value, $expire = 0) {
		if (0 >= intval($expire)) {
			$expire = $this->timeout;
		}
		return self::$handler->replace($key, $value, MEMCACHE_COMPRESSED, $expire);
	}

	/**
	 * 删除内容
	 */
	public function deleteCache($key, $expire = 0) {
		if ($this->getCache($key)) {
			return self::$handler->delete($key, $expire);
		}
		return false;
	}

	/**
	 * 清空
	 */
	public function truncateCache() {
		return self::$handler->flush();
	}

	public function __destruct() {
		return self::$handler->close();
	}
}
?>
