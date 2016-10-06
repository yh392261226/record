<?php
/**
 * php 操作redis
 *
 *
 *
 *
 */

Class RedisLib
{
	private static $handler = null; //redis链接句柄
	public static $host; //redis服务器地址
	public static $port; //redis端口
	public static $pass; //redis auth密码
	
	public function __construct()
	{
		if (false == $this->connection())
		{
			die('Can not connect to redis server:' . self::$host . ':' . self::$port);
		}
		
	}

	/**
	 * 链接redis句柄
	 * 单间链接
	 */
	private function connection()
	{
		if ( null === self::$handler )
		{
			self::$handler = new Redis();
		}
		$link = self::$handler -> connect(self::$host, self::$port);
		if (false == $link)
		{
			return false; //链接失败
		}
	}

	/**
	 * 获取内容
	 *
	 */
	public function getKey($key)
	{
		return self::$handler ->
	}


	public function __get($key)
	{
		if (isset($this->$key))
		{
			return $this->$key;
		}
	}

	public function __set($key, $value)
	{
		$this->$key = $value
	}
	
	public function __destruct()
	{
	
	}
}
?>
