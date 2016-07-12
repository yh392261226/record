<?php
/**
 * 读取系统报错的report内容
 *
 */
$reportpath = '/data/wwwroot/report';
$logpath = '/data/tools/report/log';

$logname = isset($_GET['log']) ? trim($_GET['log']) : '';
if ('' != $logname)
{
  if (!file_exists($reportpath . '/' . $logname))
  {
    echo 'Can not find the log ' . $logname;
    die();
  }

  if (false == is_readable($reportpath . '/' . $logname))
  {
    $logcontent = 'logname=' . $logname;
    if (!file_exists($logpath . '/' . $logname))
    {
        file_put_contents($logpath . '/' . $logname, $logcontent);
    }
    else
    {
        $content = file_get_contents($logpath . '/' . $logname);
    }
  }
  else
  {
    $content = file_get_contents($reportpath . '/' . $logname);
  }

  if ('' != $content)
  {
    echo "<pre>";
    echo $content;
    echo "</pre>";
  }

}
else
{
    echo 'Please make sure you have type the log into the url!' . "<br> \n";
    echo 'Like this:report.php?log=123494945848';
    die();
}
