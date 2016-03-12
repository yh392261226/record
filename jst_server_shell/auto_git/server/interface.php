<?php
$log_path='./server_watching_path'; //服务端的生成文件目录
if (!empty($_POST) && trim($_POST['uname']) != '' && trim($_POST['filename']) != '')
{
	$message = 'uname=' . trim($_POST['uname']) . "\n" . 'date=' . date('Y-m-d H:i:s') . "\n";
	file_put_contents($log_path . '/' .trim($_POST['filename']) . '.wait', $message);
}
