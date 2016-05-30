<?php
$logfile='/data/ping/status.log';

if (!file_exists($logfile))
{
  die('日志文件不存在!');
}
else
{
  $logcontent=file_get_contents($logfile);
  if (!empty($logcontent) && '' != trim($logcontent))
  {
    header("Content-type: text/html; charset=utf-8");
    echo '丢包率如果数值大于0%，则说明域名访问慢，甚至打不开。';
    echo "<pre>";
    echo $logcontent;
  }
}
