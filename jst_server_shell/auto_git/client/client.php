<?php
/**
 * 接收用户传过来的要提交的内容并写入文件
 */
session_start();
header("Content-type:text/html; charset=utf-8");
$logpath = './watching_path';                           //日志地址
$filedir='/usr/local/nginx/html/soufeel-com-project';   //文件地址
$rmcheckdir=true;                                       //action为rm的时候是否允许删除文件夹 true不允许 false允许
$server='http://www.test.com/interface.php';            //server端的链接地址
$users_arr = array(
    100 => array(
        'loginname' => 'jer',
        'loginpass' => '5f7c1fbe0c096378f015584c40d5637b', //mGVz9#2z9Q{V@VrZ
        ),
    101 => array(
        'loginname' => 'jack',
        'loginpass' => '844965f68cd2cad451b1e3b07c6e5625', //d,3Tsk8iZ9xn+&gM
        ),
    102 => array(
        'loginname' => 'jenny',
        'loginpass' => 'ef25ada3e04727dfcb1f8df559942961', //x2MHhaMb6juL4$/;
        ),
    103 => array(
        'loginname' => 'lery',
        'loginpass' => '615127514be11a0fe7c51adbdddc4943', //^7FUFeu@4V]Dd3LU
        ),
    104 => array(
        'loginname' => 'ledon',
        'loginpass' => 'da50acd1d6db0b43cd6c084fb0b7b47f', //4WK.P@NJ[86MGWog
        ),
    105 => array(
        'loginname' => 'phoebe',
        'loginpass' => 'f15459b08333a06b136c6cf123dc58ac', //8R9]bdP@P8zpLn%A
        ),
    106 => array(
        'loginname' => 'vine',
        'loginpass' => 'c6f92f54a5afbd9c695218d071e7b882', //8R77bdP@P8zpLn%A
        ),
);
if (!isset($_SESSION['uid']) || intval($_SESSION['uid']) < 100)
{
	if (isset($_POST['act']) && trim($_POST['act']) == 'login' && isset($_POST['loginname']) && '' != trim($_POST['loginame']) && isset($_POST['loginpass']) && '' != trim($_POST['loginpass']))
	{
		foreach ($users_arr as $key => $val)
		{
			if (trim($_POST['loginname']) == $val['loginname'] && trim($_POST['loginnpass']) == $val['loginpass'])
			{
				$_SESSION['uid'] = $key;
				$_SESSION['username'] = md5($val['loginname']);
				header("Location:?1");
			}
		}
	}
?>
<html>
	<head>
		<meta http-equiv="Content-type" content="text/html" charset="utf-8" />
		<title>登录</title>
	</head>
	<body>
		<form  method="post" name="login-form" action="" >
			<input type="hidden" name="act" value="login">
			<p> 用户:
				<input type="text" name="loginname" value="" />
			<p>
			<p> 密码:
				<input type="text" name="loginpass" value="" />
			</p>
			<input type="submit" name="submit" value=" 登 录 " / >
		</form>
	</body>
</html>
<?php
    exit;
}

//if (!empty($_POST['files']) && '' != trim($_POST['uname']))
if (!empty($_POST['files']))
{
	$tmpfilescheck = explode(' ', preg_replace("/\s+/", ' ', $_POST['files']));
    $action = isset($_POST['action']) ? trim($_POST['action']) : 'add';
    foreach ($tmpfilescheck as $key => $val)
    {
        if (!file_exists('../' . $val))
        {
            echo "<script>alert('请检查你填写的目录,有问题');window.location.href=history.go(-1);</script>";exit;
        }
        else
        {//验证是否需可以删除目录
            if ($rmcheckdir)
            {
                if (is_dir($val) && $action == 'rm') 
                {
                    echo "<script>alert('已经开启禁止删除目录操作，有问题请联系管理员！');window.location.href=history.go(-1);</script>";exit;
                }
            }
        }
    }
    unset($key, $val, $tmpfilescheck);
	if (!isset($_POST['commit']) || trim($_POST['commit']) == '') $_POST['commit'] = trim($_POST['uname']) . date("Y-m-d H:i:s");
	if (!isset($_POST['filedir']) || trim($_POST['filedir']) == '') $_POST['filedir'] = $filedir;
   	$uname = isset($_POST['uname']) ? trim($_POST['uname']) : $_SESSION['username'];

    $message = 'commit=' . $_POST['commit'] . "\n" . 'uname=' . $uname . "\n" . 'action=' . $action . "\n" . 'filedir=' . trim($_POST['filedir']) . "\n" . 'files=' . preg_replace("/\s+/", ' ', $_POST['files']) . "\n";
    if (!empty($message))
    {
        $tmpfilename = trim($_POST['uname']) . '_' . date('Ymd_H-i-s');
        $result = file_put_contents($logpath . '/' . $tmpfilename . '.wait', $message);
        if ($result)
        {
            echo '提交成功,等待5分钟后即可同步至正式服务器!';
            echo "<a style='color:red;' href='?act=viewlog&logname=" . $tmpfilename . '.log' . "'>点我</a>查看提交结果：";
            exit;
        }
    }
}
if (isset($_GET['act']) && trim($_GET['act']) == 'viewlog' && trim($_GET['logname']) != '')
{
    if (file_exists($logpath . '/' . trim($_GET['logname'])))
    {
        echo "客户端：";
        echo file_get_contents($logpath . '/' . trim($_GET['logname']));
        echo "服务端：";
        echo file_get_contents($server . '?act=viewlog&filename=' . trim($_GET['logname']));
        exit;
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
        <form method="post" name="form" id="form" action="">
            <input type="hidden" name="uname" value="<?php echo $_SESSION['username'];?>" />
            <p>
            操作:<label><input type="radio" name="action" checked="true" value="add">添加</label> &nbsp;&nbsp;<label><input type="radio" name="action" id="rm" value="rm">删除</label>
            </p>
            <p>
            注释:<input type="text" name="commit" value="" />
            </p>
            <p>
            文件:<textarea name="files" style="margin: 0px; height: 260px; width: 600px;"></textarea> *必填项 每行一个文件或目录
            </p>
            <input type="button" name="button" value=" 提 交 " onclick="javascript:checkResult();" / >
        </form>
        <script type="text/javascript">
            $(function(){
                function checkResult() {
                    if (document.getElementById("rm").checked) {
                        var res=confirm('删除操作很危险，确认么？');
                        if (!res) {
                            return false;
                        }else{
                            document.getElementById('form').submit();
                        }
                    } else {
                        document.getElementById('form').submit();
                    }
                }
            })
        </script>
    </body>
</html>
