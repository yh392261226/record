<?php
/**
 * php 操作redis
 *
 *
 *
 *
 */

Class RedisLib extends Redis {
	private static $handler = null; //redis链接句柄
	public static $host; //redis服务器地址
	public static $port; //redis端口
	public static $auth = ''; //redis auth密码
	public $expire = 300; //过期时间

	public function __construct($type = '') {
		if ('' == $type) {
			if (false == $this->connection()) {
				die('Can not connect to redis server:' . self::$host . ':' . self::$port);
			}
		}
		if ('p' == $type) {
			if (false == $this->pconnection()) {
				die('Can not connect to redis server:' . self::$host . ':' . self::$port);
			}
		}

		if ('' != self::$auth) {
			self::$handler->auth(self::$auth);
		}
	}

	/**
	 * 链接redis句柄
	 * 单间链接
	 */
	private function connection() {
		if (null === self::$handler) {
			self::$handler = new Redis();
		}
		$link = self::$handler->connect(self::$host, self::$port);
		if (false == $link) {
			return false; //链接失败
		}
	}

	/**
	 * 长链接redis句柄
	 * 单间链接
	 */
	private function pconnection() {
		if (null === self::$handler) {
			$handler = new Redis();
		}
		self::$handler = $handler->connect(self::$host, self::$port);
		return self::$handler;
	}

	/**
	 * 选择数据库
	 */
	public function selectDb($number = 0) {
		if (intval($number) <= 15) {
			self::$handler->SELECT($number);
		}
	}

	/**
	 * 获取内容
	 *
	 */
	public function getCache($key) {
		return self::$handler->KEY($key);
	}

	/**
	 * 随机获取一个
	 */
	public function randomCache() {
		return self::$handler->RANDOMKEY();
	}

	/**
	 * 添加
	 */
	public function addCache($key, $value, $expire) {
		$this->setCache($key, $value, $expire);
	}

	/**
	 * 添加
	 */
	public function setCache($key, $value, $expire = 0) {
		if (0 >= intval($expire)) {
			$expire = $this->expire;
		}
		return self::$handler->SET($key, $value, $expire);
	}

	/**
	 * 替换
	 */
	public function replaceCache($key, $value, $expire = 0) {
		if ($this->checkKey($key)) {
			if (!$this->deleteCache($key)) {
				return false;
			}
		}
		return $this->setCache($key, $value, $expire);
	}

	/**
	 * 删除
	 */
	public function deleteCache($key) {
		return self::$handler->DEL($key);
	}

	/**
	 * 清空当前库
	 */
	public function truncateDbCache() {
		return self::$handler->FLUSHDB();
	}

	/**
	 * 清空全部
	 */
	public function truncateAllCache() {
		return self::$handler->FLUSHALL();
	}

	/**
	 * 检测key是否存在
	 */
	public function checkKey($key) {
		return self::$handler->EXISTS($key);
	}

	/**
	 * 移动key到指定数据库
	 */
	public function moveKey($key, $db = 0) {
		if (!$this->checkKey($key)) {
			return false;
		}
		return self::$handler->MOVE($key, $db);
	}

	/**
	 * 重命名key 存在会失败
	 */
	public function renameKey($key, $newkey) {
		if (!$this->checkKey($key) || '' == $newkey) {
			return false;
		}
		return self::$handler->RENAME($key, $newkey);
	}

	/**
	 * 重命名key  存在会覆盖
	 */
	public function renamenxKey($key, $newkey) {
		if (!$this->checkKey($key) || '' == $newkey) {
			return false;
		}
		return self::$handler->RENAMENX($key, $newkey);
	}

	/**
	 * 获取key类型
	 * none(key不存在) int(0)
	 * string(字符串) int(1)
	 * list(列表) int(3)
	 * set(集合) int(2)
	 * zset(有序集) int(4)
	 * hash(哈希表) int(5)
	 */
	public function getKeyType($key) {
		if (!$this->checkKey($key)) {
			return false;
		}
		return self::$handler->TYPE($key);
	}

	/**
	 * 更新过期时间
	 */
	public function setKeyExpire($key) {
		if (!$this->checkKey($key)) {
			return false;
		}
		return self::$handler->EXPIRE($key, $this->expire);
	}

	/**
	 * 更新过期时间 unix时间戳
	 */
	public function setKeyExpireByUnix($key, $expire = 0) {
		if (!$this->checkKey($key)) {
			return false;
		}
		if (0 >= intval($expire)) {
			$expire = time() + $this->expire;
		}
		return self::$handler->EXPIREAT($key, $expire);
	}

	/**
	 * 获取key的过期时间
	 */
	public function getKeyExpire($key) {
		if (!$this->checkKey($key)) {
			return false;
		}
		return self::$handler->TTL($key);
	}

	/**
	 * 移除key的生存时间
	 */
	public function expiredKey($key) {
		if (!$this->checkKey($key)) {
			return false;
		}
		return self::$handler->PERSIST($key);
	}

	/**
	 * 获取全部key
	 */
	public function getKeys() {
		return self::$handler->KEYS();
	}

	public function __destruct() {
		return self::$handler->close();
	}
}
?>
