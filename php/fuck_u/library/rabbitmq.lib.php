<?php
/**
 * rabbitmq 队列
 *
 *
 *
 *
 */
class RabbitmqLib {
	private static $handler = null;
	public static $host = 'localhost';
	public static $port = '5672';
	public static $user = 'guest';
	public static $password = 'guest';
	public $channel = '';

	public function __construct() {
		$this->connection();
	}

	private function connection() {
		if (null === self::$handler) {
			$link = new AMQPStreamConnection(self::$host, self::$port, self::$user, self::$password);
			self::$handler = $link->channel();
		}
	}

}
