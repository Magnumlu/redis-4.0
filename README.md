该分支是redis-4.0的cmake自动编译版本，通过cmake自动生成Makefile。

编译方法和cmake常规使用方法一样，你只用进入redis-4.0的主目录执行以下两句命令：
$ cmake .
$ make
通过以上方法编译生成的执行文件全部在src子目录中。

如果你想把执行文件安装在其他地方，可以在src/CMakeLists.txt中通过修改CMAKE_INSTALL_PREFIX的值进行编译，
通过执行sudo make install,将默认安装在/usr/local/bin目录下。
