#!/usr/local/php/bin/php
<?php
  //log文件地址
  $log_file = '/data/watching_php-fpm/log/';
  if (!file_exists($log_file))
  {
    $lasttime = file_get_contents($log_file);
    if ('' != trim($lasttime))
    {
      echo date('Y-m-d H:i:s', $lasttime);die();
    }
    die('Last time is empty!');
  }
  die('Log file dose not exists!')
?>
