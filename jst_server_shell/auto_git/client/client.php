<?php
/**
 * 接收用户传过来的要提交的内容并写入文件
 */
header("Content-type:text/html; charset=utf-8");
$logpath = './watching_path'; //生成文件所在目录 即shell的监听目录
if (!empty($_POST['files']) && '' != trim($_POST['uname']))
{
    $message = 'commit=' . $_POST['commit'] . "\n" . 'uname=' . trim($_POST['uname']) . "\n" . 'filedir=' . trim($_POST['filedir']) . "\n" . 'files=' . preg_replace("/\s+/", ' ', $_POST['files']) . "\n";
    if (!empty($message))
    {
        file_put_contents($logpath . '/' . trim($_POST['uname']) . '_' . date('Ymd_H-i-s') . '.wait', $message);
    }
}
?>

<html>
    <head>
        <meta http-equiv="Content-type" content="text/html" charset="utf-8" />
        <title></title>
    </head>
    <body>
        <form method="post" name="form1" action="">
            <p>
            用户:<input type="text" name="uname" value="" />
            </p>
			<p>
			目录:<input type="text" name="filedir" value="" />
			</p>
            <p>
            注释:<input type="text" name="commit" value="" />
            </p>
            <p>
            文件:<textarea name="files"></textarea>
            </p>
            <input type="submit" name="submit" value=" 提 交 " / >
        </form>
    </body>
</html>
