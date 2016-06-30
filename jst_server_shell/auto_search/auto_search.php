<?php
/**
 *  自动搜索
 *      落文件锁
 *
 */
//落文件锁的地址
$lock_path="/data/wwwroot/jst_server_shell/auto_search/watching";
//回显地址
$return_path="/data/wwwroot/jst_server_shell/auto_search/returns";
//操作人
$operater=array('a', 'b', 'c', 'd');
$tmptime = date('YmdHis');

if (isset($_POST['act']) && trim($_POST['act']) == 'search')
{
    $uname = isset($_POST['uname']) ? trim($_POST['uname']) : 'who';
    /**$contents = array(
        's_path' => isset($_POST['path']) ? trim($_POST['path']) : '',
        's_ext'  => isset($_POST['ext']) ? trim($_POST['ext']) : '',
        's_keywords' => isset($_POST['keywords']) ? trim($_POST['keywords']) : '',
        'returnfile' => isset($_POST['returnfile']) ? trim($_POST['returnfile']) : $tmptime . '.log'
    );*/
    $spath = isset($_POST['path']) ? trim($_POST['path']) : '';
    $sext = isset($_POST['ext']) ? trim($_POST['ext']) : '';
    $skeywords = isset($_POST['keywords']) ? trim($_POST['keywords']) : '';
    $sreturnfile = isset($_POST['returnfile']) ? trim($_POST['returnfile']) : $tmptime . '.log';
    $message = 's_path=' . $spath . "\n" . 's_ext=' . $sext . "\n" . 's_keywords=' . $skeywords . "\n" . 's_returnfile=' . $uname .'_'. $sreturnfile . "\n"; 
    file_put_contents($lock_path . '/' . $uname . '_' . $tmptime . '.search', $message);
    header("Location:?returnfile=" . $uname . '_' . $sreturnfile);
}
elseif (isset($_GET['act']) && trim($_GET['act']) == 'view' && isset($_GET['returnfile']) && trim($_GET['returnfile']) != '')
{
    echo file_get_contents($return_path . '/' . trim($_GET['returnfile']));
}
else
{
    $returnfile = $tmptime . '.log';
?>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>脚本搜索</title>
    </head>
    <body>
        <div style="">
            <form method="post" name="search-from" action="">
                操作人：<input type="text" name="uname" value="" id="uname" />
                <?php
    if (!empty($operater))
    {
        foreach ($operater as $key => $val)
        {
            echo "<label><input type='radio' name='operater' id='operater_" . $val . "' onclick='checkuser(this.value)' value='" . $val . "' >" . $val . "</label>";
        }
        unset($operater, $key, $val);
    }
                ?>
                <br />
                目  录：<input type="text" name="path" value="/" />
                后缀名：<input type="text" name="ext" value="php,js,pthml" />
                关键字：<input type="text" name="keywords" value="keywords" />
                <input type="hidden" name="act" value="search" />
                <input type="hidden" name="returnfile" value="<?php echo $returnfile;?>" />
                <input type="submit" name="search" value="Search" />
                <input type="reset" name="reset" value="Reset" />
            </form>
        </div>
        <?php
            if (isset($_GET['returnfile']) && trim($_GET['returnfile']) != '')
            {
        ?>
        <div style="color:red; font-size:22px;">请等待几分钟后再点击View按钮</div>
        <div style="">
            <form method="get" name="view-form" action="">
                <input type="text" name="returnfile" value="<?php echo isset($_GET['returnfile']) ? trim($_GET['returnfile']) : '';?>" /> 
                <input type="hidden" name="act" value="view" />
                <input type="submit" name="view" value="View">
            </form>
        </div>
        <?php
            }
        ?>
    <script type="text/javascript">
        function checkuser(val) {
            document.getElementById('uname').value = val;
        }
    </script>
    </body>
</html>
<?php
}
?>
