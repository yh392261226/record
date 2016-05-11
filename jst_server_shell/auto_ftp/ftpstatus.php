<?php
/**
 * 获取状态
 *
 */
$log_path = '/data/auto_ftp/log/';
if (isset($_GET['act']) && trim($_GET['act']) == 'status')
{
 $ftpcontent = '';
 if (file_exists($log_path . 'lock'))
 {
     $ftpcontent = file_get_contents($log_path . 'lock');
 }
 if ('' != trim($ftpcontent))
 {

     echo '开启中,结束时间：' . $ftpcontent;exit();
 }
 echo '关闭中';exit();
}
