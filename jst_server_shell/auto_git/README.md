服务器需要有curl支持 <br \n>
而且支持inotify <br \n>
inotify 安装 <br \n>
wget --no-check-certificate http://github.com/downloads/rvoicilas/inotify-tools/inotify-tools-3.14.tar.gz <br \n>
tar -zxvf inotify-tools-3.14.tar.gz <br \n>
cd inotify-tools-3.14 <br \n>
./configure <br \n>
make <br \n>
make install <br \n>

默认安装到/usr/local/bin目录 <br \n>
*********************** <br \n>
如果遇到以下错误： <br \n>
inotifywait: error while loading shared libraries: libinotifytools.so.0: cannot open shared object file: No such file or directory <br \n>
解决办法： <br \n>
32位系统：ln -s /usr/local/lib/libinotifytools.so.0 /usr/lib/libinotifytools.so.0 <br \n>
64位系统：ln -s /usr/local/lib/libinotifytools.so.0 /usr/lib64/libinotifytools.so.0 <br \n>
** <br \n>

client为客户端 客户端部署在用户修改的测试机上 <br \n>
 <br \n>
server为服务端 服务端部署在外网的生产环境上*************** <br \n>
