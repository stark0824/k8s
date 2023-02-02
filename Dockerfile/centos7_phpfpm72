# docker build -t php-fpm:test_v1.0 -f centos7_phpfpm72 .
# author stark v0.2
# 基于centos7 +  php-fpm:7.2

FROM centos:centos7


# https://www.php.net/releases/
# wget https://www.php.net/distributions/php-7.2.28.tar.gz

ENV PHP_VERSION php-7.2.28

# 安装依赖编译的依赖 和 常用工具
RUN yum -y update && yum -y install gcc gcc-c++ autoconf automake zlib zlib-devel openssl openssl-devel pcre pcre-devel libxml2 libxml2-devel sqlite-devel wget curl libtool php-dev php-pear vim php-devel


#下载php版本

RUN mkdir $HOME/Package/ && cd $HOME/Package/ && wget https://www.php.net/distributions/${PHP_VERSION}.tar.gz && tar -zxvf ${PHP_VERSION}.tar.gz

# 安装和编译
RUN $HOME/Package/${PHP_VERSION}/configure --prefix=/usr/local/php7 --enable-fpm --enable-debug && make && make install

# 为php命令建立软链接，加入到环境变量中
RUN ln -s /usr/local/php7/bin/php /usr/local/bin/php && cp $HOME/Package/${PHP_VERSION}/php.ini-development /usr/local/php7/lib/php.ini

# 为php-fpm命令建立软链接，加入到环境变量中
RUN ln -s /usr/local/php7/sbin/php-fpm /usr/local/sbin/php-fpm && cp /usr/local/php7/etc/php-fpm.conf.default /usr/local/php7/etc/php-fpm.conf && cp /usr/local/php7/etc/php-fpm.d/www.conf.default /usr/local/php7/etc/php-fpm.d/www.conf


# 设置全局php.ini,设置后可以自动添加
# RUN pear config-set php_ini /usr/local/php7/etc/php.ini 


#使用pear安装扩展 https://pear.php.net/

COPY libdatrie-0.2.4.tar.gz  /root/Pack/

#设置启动脚本 
RUN  echo "php-fpm && tail -f /dev/null" > $HOME/run.sh 

#设置php-fpm全局变量
# RUN ln -s /usr/local/php7/sbin/php-fpm /usr/bin/php-fpm  && \
# echo "php-fpm -c /usr/local/php7/etc/php.ini -y /usr/local/php7/etc/php-fpm.conf \
# && tail -f /dev/null" > /run.sh

WORKDIR /root

CMD ["/bin/bash","./run.sh"]

EXPOSE 9000

## 待修复问题 docker 做不到后台运行 ？
## 启动命令不好使 ？

