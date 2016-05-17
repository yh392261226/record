<?php
/**
 * 自动执行ftp的开启及关闭
 *
 */
 session_start();
//配置文件
 $userlists = array(
     array(
         'ip' =>'server1',
         'username' => 'user1',
         'userpass' => 'pass1',
     ),
     array(
         'ip' => 'server2',
         'username' => 'user2',
         'userpass' => 'pass2',
     ),
 );
 // 每个月的限制日
 $unopenday = array(
     '12',   //每个月的12号为限制日
     '0',
 );
//激活shell的log地址
$log_path = '/data/auto_ftp/log/';

function getIPByName($username, $userlists)
{
    if ('' != $username && !empty($userlists))
    {
        foreach ($userlists as $key => $val)
        {
            if ($val['username'] == $username)
            {
                return $val['ip'];
            }
        }
    }
    return '';
}

if (isset($_POST['act']) && trim($_POST['act']) == 'ftp'){
    //已经登录 落地用户输入数据
    if (isset($_SESSION['loginmark']) && intval($_SESSION['loginmark']) == '1')
    {
        //验证是否在限制日内
        if (in_array(date('d'), $unopenday))
        {
            echo "<script>alert('今天是限制日 不能开启ftp !!!');window.close();</script>";exit;
        }
        $_POST['usetime'] = isset($_POST['usetime']) ? intval($_POST['usetime']) : '30';
        $_POST['server']  = isset($_POST['server'])  ? trim($_POST['server'])    : (isset($_SESSION['serverip']) ? $_SESSION['serverip'] : '');
        $action = false;
        $action = file_put_contents($log_path . date('Y-m-d_H_i_s') . trim($_SESSION['username']) . '.do', 'username=' . trim($_SESSION['username']) . "\n" . 'server=' . $_POST['server'] . "\n" . 'usetime=' . $_POST['usetime']) . 'dotime=' . date('Y-m-d H:i:s');
        if (!$action)
        {
			echo '<meta http-equiv="refresh" content="3;url=?1">';
            echo "<b>执行失败</b>，3秒后自动跳转。 如果您的浏览器没有跳转，请<a href='?1'>点击</a>";exit;
        }
        else
        {
			echo '<meta http-equiv="refresh" content="3;url=?1">';
            echo "<b>执行成功</b>，3秒后自动跳转。 如果您的浏览器没有跳转，请<a href='?1'>点击</a>";exit;
        }
    }
    else
    {
        header("HTTP/1.1 404 Not Found");exit;
    }
}
else if (isset($_POST['act']) && trim($_POST['act']) == 'login')
{
    //登录
    $_POST['username'] = isset($_POST['username']) ? trim($_POST['username']) : '';
    $_POST['userpass'] = isset($_POST['userpass']) ? trim($_POST['userpass']) : '';
    if ('' != $_POST['username'] && '' != $_POST['userpass'])
    {
        foreach ($userlists as $key => $val)
        {
            if ($val['username'] == $_POST['username'] && $val['userpass'] == $_POST['userpass'])
            {
                $_SESSION['username'] = $_POST['username'];
                $_SESSION['loginmark'] = '1';
                $_SESSION['serverip'] = getIPByName($_POST['username'], $userlists);

                header("Location:?1");
            }
        }
    }
    else
    {
        header("HTTP/1.1 404 Not Found");exit;
    }
}
 ?>
 <html>
    <head>
        <meta http-equiv="content-type" content="text/html" charset="utf-8" />
        <title>自动开启/关闭ftp</title>
    </head>
    <body>
<?php
//登录后
if (isset($_SESSION['loginmark']) && intval($_SESSION['loginmark']) == '1')
{
    $ftp1status = $ftp2status = '';
    $ftp1status = file_get_contents('http://www.web1tools.com/auto_ftp/ftpstatus.php?act=status');
    $ftp2status = file_get_contents('http://www.web2tools.com/auto_ftp/ftpstatus.php?act=status');
?>
        <form method="post" name="ftp_form" action="">
            <input type="hidden" name="act" value="ftp" />
            使用时间：<input type="text" name="usetime" value="" />分钟
            服 务 器：<input type="text" name="server" value="<?php echo $_SESSION['serverip'];?>" disabled />
            <input type="submit" name="submit" value=" Submit " />
            <input type="reset" name="reset" value=" Reset " />
        </form>
        <div style="color:red;">现在server1的ftp状态是：<?php echo $ftp2status;?></div>
        <div style="color:green;">现在server2的ftp状态是：<?php echo $ftp1status;?></div>
<?php
}
else
{
//登录前
?>
        <form method="post" name="login_form" action="">
            <input type="hidden" name="act" value="login" />
            用户名：<input type="text" name="username" value="" />
            密  码：<input type="password" name="userpass" value="" />
            <input type="submit" name="submit" value=" Login " />
        </form>
<?php
}
?>
    </body>
 </html>
