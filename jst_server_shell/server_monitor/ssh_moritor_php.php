<?php
/**
 * 服务器 落锁/解锁 控制器
 * 利用post请求 传递act 参数来决定落锁/解锁
 * 配合服务器监听脚本实现ssh自动 锁定或解锁  【属于安全预防脚本】
 */
session_start();
header("Content-type: text/html; charset=utf-8");
define('LOCK_PATH', '/www/'); //状态锁地址
define('PASSWORD', '3f572fcb0f9af03848738946954b8c43'); //密码：md5('mima')

//落锁/解锁
//$status lock/unlock
function land_lock_status($status='lock', $ip='')
{
    if ('' == trim($ip))
    {
        $ip = 'all';
    }
    if ($status == 'lock')
    {
        return file_put_contents(LOCK_PATH . 'status.lock', $ip . ' lock at ' . date('Y-m-d H:i:s'));
    }
    else
    {
        return file_put_contents(LOCK_PATH . 'status.unlock', $ip . ' unlock at ' . date('Y-m-d H:i:s'));
    }
}

function checkSession()
{
    if (isset($_SESSION['logined']) && trim($_SESSION['logined']) == 'yes')
    {
        return true;
    }
    header("Location:?act=login");
    exit();
}

if (!empty($_POST) && isset($_POST['act']) && trim($_POST['act']) == 'lock') //锁定
{
    checkSession();
    if (land_lock_status('lock', trim($_POST['ip'])))
    {
        echo 'lock ok'; exit();
    }
    echo 'lock faild'; exit();
}
elseif (!empty($_POST) && isset($_POST['act']) && trim($_POST['act']) == 'unlock' ) //解锁
{
    checkSession();
    if (land_lock_status('unlock', trim($_POST['ip'])))
    {
        echo 'unlock ok'; exit();
    }
    echo 'unlock faild'; exit();
}
elseif (!empty($_POST) && trim($_POST['act']) == 'dologin')
{
    if (isset($_POST['password']) && md5(trim($_POST['password'])) == PASSWORD)
    {
        $_SESSION['logined'] = 'yes';
        header("Location:?act=status");
    }
    else
    {
        header("Location:?act=login");
    }
}
/*elseif ((empty($_GET) && empty($_POST)) ||  (isset($_GET['act']) && !in_array(trim($_GET['act']), array('login', 'dologin', 'lock', 'unlock', 'status'))))
{
    echo "Hi, nice day it is!"; exit();
}*/
?>
<html>
    <head>
        <title></title>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    </head>
    <body>
        <?php
        if (!isset($_GET['act']) || trim($_GET['act']) == '' || trim($_GET['act']) == 'login')
        {
        ?>
        <form method="post" name="form" action="?act=dologin">
            <input type="hidden" name="act" value="dologin" />
            Password:<input type="password" value="" name="password" />
            <input type="submit" name="submit" value=" Login " />
        </form>
        <?php
        }
        elseif (isset($_GET['act']) && trim($_GET['act']) == 'status')
        {
        ?>
        <form method="post" name="form" action="">
            status:
            <select name="act">
                <option value="">operate</option>
                <option value="lock">lock</option>
                <option value="unlock">unlock</option>
            </select>
            ip:
            <input type="text" name="ip" value="" />
            <input type="submit" name="submit" value=" Submit " />
        </form>
        <?php
        }
        if (isset($_GET['show']) && intval($_GET['show']) == 1)
        {
            $denies=file_get_contents('/etc/hosts.deny');
            echo "<pre>";
            print_r($denies);
        }
        ?>
    </body>
</html>
