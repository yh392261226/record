<?php
$log_path='./server_watching_path'; //服务端的生成文件目录
if (!empty($_POST) && isset($_POST['uname']) && trim($_POST['uname']) != '' && isset($_POST['filename']) && trim($_POST['filename']) != '')
{
	$message = 'uname=' . trim($_POST['uname']) . "\n" . 'date=' . date('Y-m-d H:i:s') . "\n";
	file_put_contents($log_path . '/' .trim($_POST['filename']) . '.wait', $message);
}

if (isset($_GET['filename']) && trim($_GET['filename']) != '' && isset($_GET['act']) && trim($_GET['act']) == 'viewlog')
{
    if (file_exists($log_path . '/' . trim($_GET['filename'])))
    {
        echo file_get_contents($log_path . '/' . trim($_GET['filename']));
        exit;
    }
}
