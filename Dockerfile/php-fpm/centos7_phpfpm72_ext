# docker build -t php-fpm:test_v1.0 -f centos7_phpfpm72 .
# author stark v0.2
# 基于centos7 +  php-fpm:7.2

FROM centos:centos7


# https://www.php.net/releases/
# wget https://www.php.net/distributions/php-7.2.28.tar.gz

ENV PHP_VERSION php-7.2.28

WORKDIR /Package

COPY . .

# 安装依赖编译的依赖 和 常用工具
RUN yum -y update && yum -y install gcc gcc-c++ autoconf automake \
zlib zlib-devel openssl openssl-devel pcre pcre-devel \
libxml2 libxml2-devel sqlite-devel wget curl libtool \
 php-dev php-pear vim php-devel


#下载php版本

RUN mkdir $HOME/Package/ && cd $HOME/Package/ \
&& wget https://www.php.net/distributions/${PHP_VERSION}.tar.gz \
&& tar -zxvf ${PHP_VERSION}.tar.gz

# 安装和编译
# 指定安装路径 --prefix 
# --with-config-file-path=

# error: cURL version 7.10.5 or later is required to compile php with cURL support
RUN yum -y install libcurl libcurl-devel

# error：Please reinstall the BZip2 distribution
# yum install bzip2 bzip2-devel

RUN $HOME/Package/${PHP_VERSION}/configure --prefix=/usr/local/php7 \
 --with-php-config=/usr/local/php7/bin/php-config \
 --enable-fpm  \
 --enable-debug \
 --enable-opcache \
 --enable-zip \
 --enable-sockets \
 --with-pdo-mysql \
 --with-mysqli \
 --with-pear \
 --with-curl \
 --with-openssl && make && make install

# 为php命令建立软链接，加入到环境变量中
RUN ln -s /usr/local/php7/bin/php /usr/local/bin/php && \
cp $HOME/Package/${PHP_VERSION}/php.ini-development /usr/local/php7/lib/php.ini

# 为php-fpm命令建立软链接，加入到环境变量中
RUN ln -s /usr/local/php7/sbin/php-fpm /usr/local/sbin/php-fpm \ 
&& cp /usr/local/php7/etc/php-fpm.conf.default /usr/local/php7/etc/php-fpm.conf \ 
&& cp /usr/local/php7/etc/php-fpm.d/www.conf.default /usr/local/php7/etc/php-fpm.d/www.conf


#使用pear安装扩展 https://pear.php.net/

# redis-4.2.0  pecl wget 方式
RUN wget https://pecl.php.net/get/redis-4.2.0.tgz && \
tar -zxvf redis-4.2.0.tgz &&  cd redis-4.2.0 && phpize \
&&  ./configure --with-php-config=/usr/local/php7/bin/php-config \
&& make && make install && echo 'extension=redis.so' >> /usr/local/php7/lib/php.ini


# yaf yaf-3.0.7 https://pecl.php.net/get/yaf-3.0.7.tgz

RUN wget https://pecl.php.net/get/yaf-3.0.7.tgz && \
tar -zxvf yaf-3.0.7.tgz &&  cd yaf-3.0.7.tgz && phpize \
&&  ./configure --with-php-config=/usr/local/php7/bin/php-config \
&& make && make install && echo 'extension=redis.so' >> /usr/local/php7/lib/php.ini

#设置启动脚本 
RUN  echo "php-fpm && tail -f /dev/null" > $HOME/run.sh 

CMD ["/bin/bash","sh $HOME/Package/run.sh"]

EXPOSE 9000