<?php
/**
 * 每日监控服务器上的数据
 *
 *
 *
 */
 class Moritor
 {
     public static $sserver    = '';             //服务器名称
     public static $sshellpath = '';             //shell地址
     public $icurtime          = time();         //当前时间
     public $sprefix           = '';             //文件前缀
     public $sext              = '';             //文件后缀
     public $slogpath          = '';             //日志文件地址


     /**
      * function: __contruct
      * desc:     构造函数
      * para:     服务器名称:    $server,
      *           shell文件地址: $shellpath
      *           日志文件地址:  $logpath
      * return:   无
      */
     public function __construct($sserver='', $sshellpath='', $logpath='')
     {
        $this->run($sserver='', $sshellpath='', $logpath='');
     }


     /**
      * function: run
      * desc:     初始化函数
      * para:     服务器名称:    $server,
      *           shell文件地址: $shellpath
      *           日志文件地址:  $logpath
      * return:   无
      */
     private function run($sserver='', $sshellpath='')
     {
        if ('' != trim($sserver)) self::$sserver = $sserver;
        if ('' != trim($sshellpath)) self::$sshellpath = $sshellpath;
     }

     /**
      * function: getDateStyle
      * desc:     按照style形式获取当前日期
      * para:     日期形式: $style
      * return:   日期
      */
     private function getDateStyle($sstyle='Y-m-d')
     {
        if ('' != $sstyle)
            return date($sstyle, $this->icurtime);
        else
            return date('Y-m-d', $this->icurtime);
     }

     /**
      * function: getFileList
      * desc:     获取指定路径下文件列表
      * para:     目录:           $spath
      *           是否读取隐藏文件: $bhidden
      * return:   spath下文件列表
      */
     public function getFileList($spath = '', $bhidden = false)
     {
        if ($this->checkFileOrPath($sfile) != 2)
        {
            return 'error:path has something wrong';
        }
        $afilearr = array();
        if (is_dir($spath)) {
            $ohandler = opendir($spath);
            while (($sfile = readdir($ohandler)) !== false) {
                if (!$bhidden)
                {
                    if ($sfile == '.' || $sfile == '..') {
                        continue;
                    }
                }
                if (is_file($spath.'/'.$sfile)) {
                    $afilearr[] = $sfile;
                } elseif (is_dir($spath.'/'.$sfile)) {
                    $afilearr[$sfile] = $this->getFileList($spath.'/'.$sfile);
                }
            }
            closedir($ohandler);
        }
        return $afilearr;
     }

     private function countFileLines($sfile)
     {
        $ilines = 0 ;
        if ($this->checkFileOrPath($sfile) != 1)
        {
            return 'error:file has something wrong';
        }
        $ohandler = fopen($sfile , 'r');
        if(!$ohandler)
        {
            return 'error:can not read file';
        }
        else
        {
            if(version_compare(PHP_VERSION, '5.0.0', '>='))
            {
                //获取文件的一行内容，注意：需要php5才支持该函数；
                while (stream_get_line($ohandler,8192,"\n"))
                {
                   $ilines++;
                }
                fclose($ohandler);
            }
            else
            {
                $ilines = count(file($sfile));
            }
        }
        return $ilines;
     }

     /**
      * function: getFileContentByLines
      * desc:     获取指定文件的指定行数的内容
      * para:     文件:       $sfile
      *           起始行:     $istartline
      *           结束行:     $iendline
      *           读取方式:   $smethod
      * return:   内容
      */
     private function getFileContentByLines($sfile, $istartline=1, $iendline=100, $smethod='r')
     {
         if (intval($istartline) < 1) $istartline = 1;
         if (intval($iendline) < 1) $iendline = $this->countFileLines($sfile);
         if (intval($iendline) < intval($istartline))
         { //说明文件为空或结束行小于起始行
             return 'error:endline must bigger than startline';
         }

         if ($this->checkFileOrPath($sfile) != 1)
         {
             return 'error:file has something wrong';
         }

         $aresult = array();
         $icount = $iendline - $istartline;
         if(version_compare(PHP_VERSION, '5.1.0', '>='))
         {// 判断php版本（因为要用到SplFileObject，PHP>=5.1.0）
             $ohandler = new SplFileObject($sfile, $smethod);
             $ohandler->seek($istartline - 1);// 转到第N行, seek方法参数从0开始计数
             for($i = 0; $i <= $icount; ++$i)
             {
                 $aresult[] = $ohandler->current();// current()获取当前行内容
                 $ohandler->next();// 下一行
             }
         }
         else
         {//PHP<5.1
             $ohandler = fopen($sfile, $smethod);
             if(!$ohandler) return 'error:file has something wrong';
             for ($i = 1; $i< $istartline; ++$i)
             {// 跳过前$startLine行
                 fgets($ohandler);
             }
             for($i; $i <= $iendline; ++$i)
             {
                 $aresult[] = fgets($ohandler);// 读取文件行内容
             }
             fclose($ohandler);
         }
         return $aresult;
         //return array_filter($aresult); // array_filter过滤：false,null,''
     }


     /**
      * function: getFileContent
      * desc:     获取指定文件内容
      * para:     文件:       $sfile
      *           读取方式:   $stype 全部：all 限定：[0],[10]
      * return:   内容
      */
     public function getFileContent($sfile, $stype='all')
     {
        if ($this->checkFileOrPath($sfile) != 1)
        {
            return 'error:file has something wrong';
        }

        if ('' == trim($stype)) $stype = 'all';
        if ($stype == 'all')
        {
            return file_get_contents($sfile);
        }
        if (false !== strpos($stype, ','))
        {
            $atmp = explode(',', $stype);
            if (!empty($atmp))
            {
                return $this->getFileContentByLines($sfile, intval($atmp[0]), intval($atmp[1]), $smethod='r');
            }
            return file_get_contents($sfile);
        }
        else
        {
            return file_get_contents($sfile);
        }

     }

     /**
      * function: writeFileContent
      * desc:     获取指定文件内容
      * para:     文件:       $sfile
      *           读取方式:   $stype 覆盖：overwriten 追加：append 在前面:unshift
      * return:   内容
      */
     public function writeFileContent($sfile, $scontent='', $stype='append')
     {
        if ($this->checkFileOrPath($sfile) != 1)
        {
            return 'error:file has something wrong';
        }
        if ('' != trim($stype))
        {
            switch($stype)
            {
                case 'append':
                    return file_put_contents($sfile, $scontent, FILE_APPEND);
                    break;
                case 'overwriten':
                    return file_put_contents($sfile, $scontent);
                    break;
                case 'unshift'://适用于小文件
                    $stmpcontent = $this->getFileContent($sfile, $stype='all');
                    $stmpcotnent = $scontent . $stmpcontent;
                    return file_put_contents($sfile, $stmpcotnent);
                    break;
            }
        }
     }

     /**
      * function: checkFileOrPath
      * desc:     获取指定文件内容
      * para:     文件:       $sfile
      * return:   0:文件不存在 1:文件存在 2:是目录 3:不可读 4:不可写
      */
     public function checkFileOrPath($sfile)
     {
        if ('' != trim($sfile))
        {
            if (!file_exists($sfile))
            {
                return 0;
            }
            if (!is_readable($sfile))
            {
                return 3;
            }
            if (!is_writeable($sfile))
            {
                return 4;
            }
            if (is_dir($sfile))
            {
                return 2;
            }
            return 1;
        }
        return 0;
     }


     /**
      * function: __destruct
      * desc:     析构函数 清理
      * para:     无
      * return:   无
      */
     public function __destruct()
     {
        $this->icurtime     = '';
        $this->sshellpath   = '';
        $this->logpath      = '';
     }
 }
