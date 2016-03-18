<?php
/**
 * 接收用户传过来的要提交的内容并写入文件
 *
 *
 *
 *
 */
header("Content-type:text/html; charset=utf-8");
$logpath = './watching_path';
$filedir='/usr/local/nginx/html/soufeel-com-project';
if (!empty($_POST['files']) && '' != trim($_POST['uname']))
{
	  $tmpfilescheck = explode(' ', preg_replace("/\s+/", ' ', $_POST['files']));
    foreach ($tmpfilescheck as $key => $val)
    {
        if (!file_exists('../' . $val))
        {
            echo "<script>alert('请检查你填写的目录,有问题');window.location.href=history.go(-1);</script>";exit;
        }
    }
    unset($key, $val, $tmpfilescheck);
	  if (!isset($_POST['commit']) || trim($_POST['commit']) == '') $_POST['commit'] = trim($_POST['uname']) . date("Y-m-d H:i:s");
	  if (!isset($_POST['filedir']) || trim($_POST['filedir']) == '') $_POST['filedir'] = $filedir;
    $message = 'commit=' . $_POST['commit'] . "\n" . 'uname=' . trim($_POST['uname']) . "\n" . 'filedir=' . trim($_POST['filedir']) . "\n" . 'files=' . preg_replace("/\s+/", ' ', $_POST['files']) . "\n";
    if (!empty($message))
    {
        $result = file_put_contents($logpath . '/' . trim($_POST['uname']) . '_' . date('Ymd_H-i-s') . '.wait', $message);
        if ($result)
        {
          exit('提交成功,等待5分钟后即可同步至正式服务器!');
        }
    }
}
?>

<html>
    <head>
        <meta http-equiv="Content-type" content="text/html" charset="utf-8" />
        <title>auto_git</title>
        <script src="http://lib.sinaapp.com/js/jquery/1.9.1/jquery-1.9.1.min.js"></script>
    </head>
    <body>
        <form method="post" name="form1" action="">
            <p>
            用户:<input type="text" name="uname" value="" /> *必填项
            </p>
            <p>
            注释:<input type="text" name="commit" value="" />
            </p>
            <p>
            文件:<textarea name="files" style="margin: 0px; height: 260px; width: 600px;"></textarea> *必填项 每行一个文件或目录
            </p>
            <input type="submit" name="submit" value=" 提 交 " onclick="javascript:checkResult();" / >
        </form>
        <script type="text/javascript">
            $(function(){
                function checkResult() {
                    $(this).form.submit();
                    $.ajax();
                }
            })
        </script>
    </body>
</html>
