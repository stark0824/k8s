# docker build -t php-fpm:k8s_v1.x -f k8s_v1.x .

FROM centos:centos7

ENV LIB_PATH /usr/local/src/
ENV PHP_COMPILE_PATH /usr/local/php7/bin/php-config
ENV PHP_INI_PATH /usr/local/php7/lib/php.ini
ENV PHP_INSTALL_PATH /usr/local/php7

WORKDIR /usr/local/src/ 

COPY . .

# 安装依赖编译的依赖 和 常用工具 
RUN yum -y update && yum -y install gcc gcc-c++ autoconf  \ 
automake zlib zlib-devel openssl openssl-devel libxml2 libxml2-devel \
sqlite-devel libtool php-dev php-pear vim php-devel \
wget curl git libcurl libcurl-devel

# 解压 安装php

RUN tar zxf /usr/local/src/php-7.2.28.tar.gz && cd /usr/local/src/php-7.2.28 && \
./configure --prefix=${PHP_INSTALL_PATH} \
 --with-php-config=${PHP_COMPILE_PATH} \
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
cp /usr/local/src/php-7.2.28/php.ini-development /usr/local/php7/lib/php.ini


# 为php-fpm命令建立软链接，加入到环境变量中
RUN ln -s /usr/local/php7/sbin/php-fpm /usr/local/sbin/php-fpm && \ 
cp /usr/local/php7/etc/php-fpm.conf.default /usr/local/php7/etc/php-fpm.conf && \ 
cp /usr/local/php7/etc/php-fpm.d/www.conf.default /usr/local/php7/etc/php-fpm.d/www.conf

# +----------------------------------------------------------------------
# | wget https://pecl.php.net/get/
# +----------------------------------------------------------------------
# redis-4.2.0 版本

RUN tar zxf /usr/local/src/redis-4.2.0.tgz &&  cd /usr/local/src/redis-4.2.0 && \
phpize && ./configure --with-php-config=/usr/local/php7/bin/php-config && \
make && make install && echo 'extension=redis.so' >> /usr/local/php7/lib/php.ini

# yaf yaf-3.0.7

RUN tar zxf /usr/local/src/yaf-3.0.7.tgz && cd /usr/local/src/yaf-3.0.7 && \
phpize && ./configure --with-php-config=/usr/local/php7/bin/php-config && \
make && make install && echo 'extension=yaf.so' >> /usr/local/php7/lib/php.ini


# swoole-4.2.11
RUN tar zxf /usr/local/src/swoole-4.2.11.tgz && cd /usr/local/src/swoole-4.2.11 && \
phpize && ./configure --with-php-config=/usr/local/php7/bin/php-config && \
make && make install && echo 'extension=swoole.so' >> /usr/local/php7/lib/php.ini


# mongodb-1.5.3

RUN tar zxf /usr/local/src/mongodb-1.5.3.tgz && cd /usr/local/src/mongodb-1.5.3 && \
phpize && ./configure --with-php-config=/usr/local/php7/bin/php-config && \
make && make install && echo 'extension=mongodb.so' >> /usr/local/php7/lib/php.ini 


# +----------------------------------------------------------------------
# | trie_filter
# +----------------------------------------------------------------------

RUN tar zxf /usr/local/src/libdatrie-0.2.4.tar.gz && \
cd /usr/local/src/libdatrie-0.2.4 && \
./configure --prefix=/usr/local/libdatrie &&  \
make && make install

RUN yum -y install unzip && cd /usr/local/src/ && \
unzip /usr/local/src/trie_filter-master.zip && \
 cd /usr/local/src/trie_filter-master/ && phpize && \
./configure --with-php-config=/usr/local/php7/bin/php-config  \ 
--with-trie_filter=/usr/local/libdatrie && \
make && make install && \
echo 'extension=trie_filter.so' >> /usr/local/php7/lib/php.ini 

# +----------------------------------------------------------------------
# | xdiff
# +----------------------------------------------------------------------

# https://pecl.php.net/get/xdiff-2.0.1.tgz


RUN tar zxf /usr/local/src/libxdiff-0.23.tar.gz && \
cd /usr/local/src/libxdiff-0.23 && \
./configure && make && make install

RUN cd ~ && wget https://pecl.php.net/get/xdiff-2.0.1.tgz && \
tar zxf ~/xdiff-2.0.1.tgz &&  cd xdiff-2.0.1 && \
phpize && ./configure --with-php-config=/usr/local/php7/bin/php-config && \
make && make install && echo 'extension=xdiff.so' >> /usr/local/php7/lib/php.ini


# 写入启动脚本
# RUN echo "php-fpm && tail -f /dev/null" > /root/run.sh  && rm -rf /usr/local/src/ 
# CMD ["/bin/bash","/root/run.sh"]

EXPOSE 80
EXPOSE 443
EXPOSE 9000

