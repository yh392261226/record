<?php
session_start();
/**
 * file:        client_server_to_server_ftp.php
 * intention:   落锁客户端文件
 * function：   通过ftp自动实现服务器与服务器之间的复制
 * date：       2016-07-15
 * author：     Json 杨浩
 */

/**
 * intention:   用户列表数组
 * notice:      用户id从31开始 即偏移量设置为>30
 */
$userlist = array(
    31 => array(
            'username' => '', //用户名
            'userpass' => '', //密码
    ),
    32 => array(
            'username' => '',
            'userpass' => '',
    ),
    33 => array(
            'username' => '',
            'userpass' => '',
    ),
);

/**
 * intention:   服务器列表
 * notice: none
 */
$serverlist = array(
    'web1' => array(
        'ip'        => '',   //ftpIP地址
        'port'      => '',   //ftp端口号
        'name'      => '',   //服务器名称
        'username'  => '',   //用户名
        'password'  => '',   //密码
    ),
    'web2' => array(
        'ip'        => '',   //ftpIP地址
        'port'      => '',   //ftp端口号
        'name'      => '',   //服务器名称
        'username'  => '',   //用户名
        'password'  => '',   //密码
    ),
    'db2' => array(
        'ip'        => '',   //ftpIP地址
        'port'      => '',   //ftp端口号
        'name'      => '',   //服务器名称
        'username'  => '',   //用户名
        'password'  => '',   //密码
    ),
    'taiwan' => array(
        'ip'        => '',   //ftpIP地址
        'port'      => '',   //ftp端口号
        'name'      => '',   //服务器名称
        'username'  => '',   //用户名
        'password'  => '',   //密码
    ),
    'weixin' => array(
        'ip'        => '',   //ftpIP地址
        'port'      => '',   //ftp端口号
        'name'      => '',   //服务器名称
        'username'  => '',   //用户名
        'password'  => '',   //密码
    ),
    'shanghai' => array(
        'ip'        => '',   //ftpIP地址
        'port'      => '',   //ftp端口号
        'name'      => '',   //服务器名称
        'username'  => '',   //用户名
        'password'  => '',   //密码
    ),
);

/**
 * intention:   其他配置参数
 */
$logpath = ''; //日志文件地址
$logext  = 'do'; //日志文件后缀

/**
 * function：   landFile
 * intention:   落锁文件
 * para：       $filepath 文件位置
 *              $content 文件内容
 * return:      true||false
 */
function landFile($filepath, $content='')
{
    //文件已存在或内容为空
    if (file_exists($filepath) || '' == trim($content))
    {
        return false;
    }
    //目录不可写
    if (!is_writable(dirname($filepath)))
    {
        return false;
    }
    return file_put_contents($filepath, $content);
}

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

/**
 * 业务逻辑部分：
 *              0:act='' && session[uid] = '' 登录表单
 *              1:act='' || act=faction 服务器同步表单
 *              2:act=history           历史记录查询
 */
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
if (isset($_POST['act']) && trim($_POST['act']) == 'action')
{
    $tmpsourceserver = isset($_POST['sourceserver']) ? trim($_POST['sourceserver']) : '';
    $tmpsourcefiles  = isset($_POST['sourcefiles']) ? trim($_POST['sourcefiles']) : '';
    if ('' == $tmpsourceserver || '' == $tmptargetserver || '' == $tmpsourcefiles)
    {
        msg('参数不正确!');
    }
    $tmpdate = date('Y-m-d_H-i-s');
    $contents = 'sourceserver=' . $tmpsourceserver . "\n" . 'sourcefiles=' . $tmpsourcefiles . "\n" . 'operatedate=' . $tmpdate . "\n" . 'operater=' . $_SESSION['username'];
    $tmpdo = landFile($logpath . '/' . $_SESSION['username'] . '_' . $tmpdate . '.' . $logext, $contents);
    if (!$tmpdo)
    {
        msg('操作失败！');
    }
    else
    {
        msg('操作成功！');
    }
}
if (isset($_POST['act']) && trim($_POST['act']) == 'history')
{
    die('What‘s the fuck???');
}
?>

<html>
    <head>
        <meta http-equiv="Content-type" content="text/html; charset=utf-8" />
        <title>服务器ftp文件拉取</title>
    </head>
    <body>
        <?php
            if (!isset($_SESSION['uid']) || intval($_SESSION['uid']) < 30)
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
                if (isset($_GET['act']) && (trim($_GET['act']) == '' || trim($_GET['act']) == 'faction'))
                {
        ?>
        <div id="action-form">
            <form method="post" name="actionform" id="actionform" action="">
                <input type="hidden" name="act" value="action" />
                <div>
                    数据源服务器：
                    <select name="sourceserver">
                        <option value="">请选择数据源服务器</option>
                        <?php
                        if (!empty($serverlist))
                        {
                            foreach ($serverlist as $key => $val)
                            {
                                echo '<option value="' . $key . '">' . $val['name'] . '</option>';
                            }
                            unset($key, $val);
                        }
                        else
                        {
                            echo '<option value="">暂无服务器</option>';
                        }
                        ?>
                    </select>
                </div>
                <div>
                    源文件：<textarea name="soucefiles"></textarea> *多个英文半角,分割
                </div>
                <div><input type="submit" name="submit" value=" 执 行 " />&nbsp; &nbsp; &nbsp; &nbsp;<input type="reset" name="reset" value=" 重 置 " /></div>
            </form>
        </div>
                <?php
                }
                elseif (isset($_GET['act']) && trim($_GET['act']) == 'fhistory')
                {
                ?>
        <div id="history-form">
            <form method="get" name="historyform" id="historyform" action="">
                <input type="hidden" name="act" value="history" />
                <div>
                    查询用户名：<input type="text" name="username" value="<?php if(isset($_GET['username']) && '' != trim($_GET['username'])){ echo trim($_GET['username']);}?>" />
                </div>
                <div>
                    查询日期：<input type="text" name="searchdate" value="<?php if(isset($_GET['searchdate']) && '' != trim($_GET['searchdate'])){ echo trim($_GET['searchdate']);}?>" />
                </div>
                <div>
                    查询源服务器：
                    <select name="sourceserver">
                        <option value="">请选择数据源服务器</option>
                        <?php
                        if (!empty($serverlist))
                        {
                            foreach ($serverlist as $key => $val)
                            {
                                $selected = '';
                                if (isset($_GET['sourceserver']) && trim($_GET['sourceserver']) == $key)
                                {
                                    $selected = 'selected="selected"';
                                }
                                echo '<option ' . $selected . ' value="' . $key . '">' . $val['name'] . '</option>';
                            }
                            unset($key, $val);
                        }
                        else
                        {
                            echo '<option value="">暂无服务器</option>';
                        }
                        ?>
                    </select>
                </div>
                <div><input type="submit" name="submit" value=" 查 询 " />&nbsp; &nbsp; &nbsp; &nbsp;<input type="reset" name="reset" value=" 重 置 " /></div>
            </form>
        </div>
        <?php
                    if (!empty($historylist))
                    {
        ?>
        <div id="history-list">
            <?php
                        foreach ($historylist as $key => $val)
                        {
                            print_r($val);
                        }
                        unset($key, $val);
            ?>
        </div>
        <?php
                    }
                }
            }
        ?>
    </body>
</html>
