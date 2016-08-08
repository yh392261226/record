<?php
session_start();
/**
 * 自动推送程序到远端的特定分支上
 * 配合shell脚本实现
 * Json杨浩
 * 2016-07-18
 */
$userlist = array(
	1 => array(
		'username' => '', //用户名
		'userpass' => '', //密码
	),
	2 => array(
		'username' => '',
		'userpass' => '',
	),
);

$logpath = ''; //日志文件地址
$logext  = 'push'; //日志文件后缀

/**
 * function:    checkUser
 * intention:   验证用户存储session
 * para:        $username 用户名
 *              $userpass 密码
 * rerturn:     true||false
 */
function checkUser($username, $userpass)
{
    if ('' == trim($username) || '' == trim($userpass))
    {
        return false;
    }
    global $userlist;
    if (!empty($userlist))
    {
        foreach ($userlist as $key => $val)
        {
            if ('' != trim($val['username']) && '' != trim($val['userpass']) && trim($val['username']) == $username && trim($val['userpass']) == $userpass)
            {
                $_SESSION['username'] = $username;
                $_SESSION['uid']      = $key;
                return true;
            }
        }
        unset($key, $val);
    }//用户列表为空不允许任何登录
    return false;
}

/**
 * function:    msg
 * intention:   消息
 * para:        $msg消息内容
 * return:
 */
function msg($msg)
{
    if ('' != trim($msg))
    {
        echo "<script>alert('" . $msg . "');window.history.go(-1);</script>";
        die();
    }
}

if (isset($_POST['act']) && trim($_POST['act']) == 'login')
{
    if (isset($_POST['username']) && isset($_POST['userpass']) && '' != trim($_POST['username']) && '' != trim($_POST['userpass']))
    {
        $check = checkUser(trim($_POST['username']), md5(trim($_POST['userpass']))); //账户明文 密码md5
        if (!$check)
        {
           msg('账户或密码不正确');
        }
        header("Location:?1");
    }
    header("Location:?1");
}

if (isset($_SESSION['uid']) && intval($_SESSION['uid']) > 0)
{
    if (isset($_POST['act']) && trim($_POST['act']) == 'action')
    {
        $tmpdate  = date('Y-m-d_H-i-s');
        $contents = 'operatedate=' . $tmpdate . "\n" . 'operater=' . $_SESSION['username'];
        $filename = $_SESSION['username'] . '_' . $tmpdate . '.' . $logext; 
        $tmpdo = file_put_contents($filename, $contents);
        if (!$tmpdo)
        {
            msg('操作失败！');
        }
        else
        {
            msg('操作成功！');
        }
    }
}
?>
<html>
    <head>
        <meta http-equiv="Content-type" content="text/html; charset=utf-8" />
        <title>服务器p2推送外网web2</title>
    </head>
    <body>
        <?php
            if (!isset($_SESSION['uid']) || intval($_SESSION['uid']) < 1)
            {
        ?>
        <div id="login-form">
            <form method="post" name="loginform" id="loginform" action="">
                <input type="hidden" name="act" value="login" />
                <div>用户名：<input type="text" name="username" value="" id="username" /></div>
                <div>密  码：<input type="password" name="userpass" value="" id="userpass" /></div>
                <div><input type="submit" name="submit" value=" 登 录 " />&nbsp; &nbsp; &nbsp; &nbsp;<input type="reset" name="reset" value=" 重 置 " /></div>
            </form>
        </div>
		<?php
			}
			else
			{
		?>
		<div id="action-form">
            <form method="post" name="actionform" id="actionform" action="">
                <input type="hidden" name="act" value="action" />
				<div><input type="submit" name="submit" value=" 执 行 " /></div>
            </form>
		</div>
		<?php
			}
		?>
    </body>
</html>
