#!/bin/bash
#####################################################
#
# 添加开发用户
#     并自动给予开发者所需的所有东西
#
#####################################################
if [ $# -lt 1 ] || [ $# -gt 2 ]; then
  echo "Add new develop user";
  echo "Usage: $0 username";
  exit 1
fi
if [ "" != "$2" ]; then
  pmark=$2 #项目标识
else
  pmark=web #默认是web
fi
newusername=$1

###配置
web_path=/www                                                                   #网站目录
shell_name=/bin/bash                                                            #登录使用的shell
shell_config_path=/etc/skel                                                     #shell配置文件地址
group_id=500                                                                    #用户组ID
group_name=www                                                                  #用户组名称
private=774                                                                     #用户家目录权限值
log_path=/wwwlogs                                                               #日志目录
nginx_conf_path=/usr/nginx/conf/vhost                                           #nginx 配置文件位置
nginx_conf_source_path=/jst_server_shell/new_developer/nginx_conf               #nginx 源配置文件位置
code_source=/jst_server_shell/new_developer/code_source/$pmark                  #程序代码文件位置
nginx_bin=/usr/nginx/sbin/nginx                                                 #nginx 执行程序位置
public_path=/www/developer/public                                               #共享目录
server_host=192.168.0.12                                                        #服务器ip地址
smbconf=/etc/samba/smb.conf                                                     #samba配置文件地址
alias_ext=com                                                                   #创建别名的后缀名

###预检测begin
if [ ! -d $code_source ]; then
  echo "Source code does not exists, please check !!!";
  exit 1;
fi
checkuname=$(cat /etc/passwd | sed -n "/^$newusername\:/p")
if [ "" != "$checkuname" ]; then
  echo "User $newusername already exists !!!";
  exit 1;
fi
###预检测end

###添加用户 1
useradd -b $web_path/$newusername -d $web_path/$newusername -g $group_id -s $shell_name -m -k $shell_config_path $newusername
if [ "$?" = "1" ]; then
  echo "Add user error";
  exit 1
fi
echo "1:add user $newusername ok!";

###创建家目录下的htdocs网站根目录 2
mkdir $web_path/$newusername/htdocs
chown -R ${newusername}:${group_name} $web_path/$newusername/htdocs
if [ "$?" = "0" ]; then
  echo "2:create htdocs for $newusername ok!";
fi

###给权限 3
chmod $private -R $web_path/$newusername
if [ "$?" = "0" ]; then
  echo "3:change the privallage of home dir ok!";
fi

###创建nginx的log日志目录及error.log文件 4
mkdir -p $log_path/${newusername}
#if [ "$?" = "0" ]; then
#  echo "4:create log path for $newusername ok!";
#fi
### 5
touch $log_path/${newusername}/error.log
touch $log_path/${newusername}/access.log
if [ "$?" = "0" ]; then
  echo "4:create error log file for $newusername ok!";
fi

###复制nginx配置文件并按照用户名修改 6
cp -r $nginx_conf_source_path $nginx_conf_path/${newusername}.${alias_ext}
#mv $nginx_conf_path/${1}.${alias_ext}/nginx_conf.conf $nginx_conf_path/${1}.${alias_ext}/${1}.${alias_ext}

###替换nginx配置源文件中目录
sed -i -e "/include\ common\/vhost\/nginx_conf\/config\/http.conf;/ c\\
include\ common\/vhost\/${newusername}.${alias_ext}\/config\/http.conf;" $nginx_conf_path/${newusername}.${alias_ext}/nginx_conf.conf;

###生成配置中的别名、错误日志地址及网站根目录
cat << EOF > $nginx_conf_path/${newusername}.${alias_ext}/config/http.conf
server_name ${newusername}.${alias_ext} www.${newusername}.${alias_ext};
index index.html index.htm index.php;
access_log $log_path/${newusername}/access.log;
error_log $log_path/${newusername}/error.log;
root $web_path/${newusername}/htdocs/;
EOF
if [ "$?" = "0" ]; then
  echo "5:Nginx config of $newusername ok!";
fi

###重启nginx 7
$nginx_bin -t   #先验证配置文件是否可用
if [ "$?" != "0" ]; then
  echo "6:Nginx config error, Please check it!!!";
  exit 1
fi
#service nginx reaload > /dev/null &
service nginx restart > /dev/null
if [ "$?" = "0" ]; then
  echo "6:restart nginx ok!";
fi

###将网站代码复制到家目录的htdocs根里 8
cp -r $code_source/* $web_path/$newusername/htdocs/

### 把一些软连接给连进来 比如media目录9
ln -s $public_path $web_path/$newusername/htdocs/media

if [ "$?" = "0" ]; then
  echo "7:copy the code for $newusername ok!";
fi
### 复制完程序代码后 再赋一次权限 10
chown -R ${newusername}:${group_name} $web_path/$newusername/htdocs/
chmod -R 777 $web_path/$newusername/htdocs/

###添加samba配置 11
cat << EOF >> $smbconf
[$newusername]
path = /data/wwwroot/$newusername
writable = no
valid users = $newusername
write list = $newusername
read list = $newusername

EOF
###重启samba服务
service smb restart > /dev/null &
if [ "$?" = "0" ]; then
  echo "8:restart samba ok!"
fi

###设置密码 12
passwd $newusername
smbpasswd -a $newusername

if [ "$?" = "0" ]; then
  echo "9:set password of $newusername ok!";
fi

### 13
echo "All done!!!";
echo "Please record the messages below";
echo "*************************************************************"
#echo "The username of the server for shell"
echo "username: ${newusername}"
#echo "The home folder of user ${newusername}"
echo "home:     $web_path/${newusername}"
#echo "Put this into your local hosts file, Windows:C:/windows/system32/drivers/etc/hosts"
echo "host:     $server_host ${newusername}.${alias_ext} www.${newusername}.${alias_ext}"
#echo "The nginx config folder";
echo "nginx:    $nginx_conf_path/${newusername}.${alias_ext}"
#echo "The webroot folder of ${newusername}"
echo "webroot:  $web_path/${newusername}/htdocs"
#echo "The nginx error log"
echo "errorlog: $log_path/${newusername}/error.log"
#echo "Samba info"
echo "samba: \\\\$server_host\\$newusername"
echo "*************************************************************"
