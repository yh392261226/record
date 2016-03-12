服务器需要有curl支持
而且支持inotify
inotify 安装
wget --no-check-certificate http://github.com/downloads/rvoicilas/inotify-tools/inotify-tools-3.14.tar.gz
tar -zxvf inotify-tools-3.14.tar.gz
cd inotify-tools-3.14
./configure
make
make install

默认安装到/usr/local/bin目录
***********************
如果遇到以下错误：
inotifywait: error while loading shared libraries: libinotifytools.so.0: cannot open shared object file: No such file or directory
解决办法：
32位系统：ln -s /usr/local/lib/libinotifytools.so.0 /usr/lib/libinotifytools.so.0
64位系统：ln -s /usr/local/lib/libinotifytools.so.0 /usr/lib64/libinotifytools.so.0
**

client为客户端 客户端部署在用户修改的测试机上

server为服务端 服务端部署在外网的生产环境上***************
