# +----------------------------------------------------------------------
# | Author:Stark
# +----------------------------------------------------------------------
# | Date:2023/02/07
# +----------------------------------------------------------------------
# | Desc: 安装依赖编译的依赖 和 常用工具 
# +----------------------------------------------------------------------
# | Shell: docker build -t php-fpm:k8s_v1.0_pure -f k8s_v1.0_pure .
# +----------------------------------------------------------------------

FROM php-fpm:centos7

ENV SRC_PATH /usr/local/src/
ENV PHP_COMPILE_PATH /usr/local/php7/bin/php-config
ENV PHP_INI_PATH /usr/local/php7/lib/php.ini
ENV PHP_INSTALL_PATH /usr/local/php7

WORKDIR /usr/local/src/ 

# 安装依赖编译的依赖 和 常用工具 
RUN yum -y update && yum -y install gcc gcc-c++ autoconf  \ 
automake zlib zlib-devel openssl openssl-devel libxml2 libxml2-devel \
sqlite-devel libtool php-dev php-pear vim php-devel \
wget curl git libcurl libcurl-devel unzip

# +----------------------------------------------------------------------
# | Desc: php-7.2.28  wget https://pecl.php.net/get/
# +----------------------------------------------------------------------
# | Shell: docker build -t php-fpm:k8s_v1.1_pure -f k8s_v1.1_pure .
# +----------------------------------------------------------------------

FROM php-fpm:k8s_v1.0_pure

RUN cd ${SRC_PATH} && wget https://www.php.net/distributions/php-7.2.28.tar.gz && \
tar zxf ${SRC_PATH}/php-7.2.28.tar.gz && cd ${SRC_PATH}/php-7.2.28 && \
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
cp /usr/local/src/php-7.2.28/php.ini-development ${PHP_INI_PATH}


# 为php-fpm命令建立软链接，加入到环境变量中
RUN ln -s /usr/local/php7/sbin/php-fpm /usr/local/sbin/php-fpm && \ 
cp /usr/local/php7/etc/php-fpm.conf.default /usr/local/php7/etc/php-fpm.conf && \ 
cp /usr/local/php7/etc/php-fpm.d/www.conf.default /usr/local/php7/etc/php-fpm.d/www.conf

# +----------------------------------------------------------------------
# | yaf yaf-3.0.7.tgz 
# +----------------------------------------------------------------------
# | swoole swoole-4.2.11.tgz
# +----------------------------------------------------------------------
# | mongodb mongodb-1.5.3.tgz 
# +----------------------------------------------------------------------
# | redis redis-4.2.0.tgz
# +----------------------------------------------------------------------

FROM php-fpm:k8s_v1.1_pure

RUN cd ${SRC_PATH} && wget https://pecl.php.net/get/redis-4.2.0.tgz && \
tar -zxvf redis-4.2.0.tgz &&  cd redis-4.2.0 && phpize \
&&  ./configure --with-php-config=${PHP_COMPILE_PATH} \
&& make && make install && echo 'extension=redis.so' >> ${PHP_INI_PATH}

RUN cd ${SRC_PATH} && wget https://pecl.php.net/get/swoole-4.2.11.tgz && \
tar -zxvf swoole-4.2.11.tgz &&  cd swoole-4.2.11 && phpize \
&&  ./configure --with-php-config=${PHP_COMPILE_PATH} \
&& make && make install && echo 'extension=swoole.so' >> ${PHP_INI_PATH}

RUN cd ${SRC_PATH} && wget https://pecl.php.net/get/yaf-3.0.7.tgz && \
tar -zxvf yaf-3.0.7.tgz &&  cd yaf-3.0.7 && phpize \
&&  ./configure --with-php-config=${PHP_COMPILE_PATH} \
&& make && make install && echo 'extension=yaf.so' >> ${PHP_INI_PATH}

RUN cd ${SRC_PATH} && wget https://pecl.php.net/get/mongodb-1.5.3.tgz && \
tar -zxvf mongodb-1.5.3.tgz &&  cd mongodb-1.5.3 && phpize \
&&  ./configure --with-php-config=${PHP_COMPILE_PATH} \
&& make && make install && echo 'extension=mongodb.so' >> ${PHP_INI_PATH}

RUN cd ${SRC_PATH} && rm -rf redis-4.2.0.tgz redis-4.2.0 \
swoole-4.2.11.tgz swoole-4.2.11 \
yaf-3.0.7.tgz yaf-3.0.7 \
mongodb-1.5.3.tgz mongodb-1.5.3

# +----------------------------------------------------------------------
# | trie_filter
# +----------------------------------------------------------------------
# | xdiff
# +----------------------------------------------------------------------

FROM php-fpm:k8s_v1.2_pure

COPY libdatrie-0.2.4.tar.gz .
COPY trie_filter-master.zip .
COPY libxdiff-0.23.tar.gz .

## trie_filter --prefix=/usr/local/libdatrie 安装目录

RUN cd ${SRC_PATH} && tar zxf libdatrie-0.2.4.tar.gz && \
cd libdatrie-0.2.4 && \
./configure --prefix=/usr/local/libdatrie &&  \
make && make install

RUN cd ${SRC_PATH} && \
unzip /usr/local/src/trie_filter-master.zip && \
 cd trie_filter-master/ && phpize && \
./configure --with-php-config=${PHP_COMPILE_PATH}  \ 
--with-trie_filter=/usr/local/libdatrie && \
make && make install && \
echo 'extension=trie_filter.so' >> ${PHP_INI_PATH}


## xdiff 
RUN cd ${SRC_PATH} && tar zxf libxdiff-0.23.tar.gz && \
cd libxdiff-0.23 && \
./configure && make && make install

RUN cd ${SRC_PATH} && wget https://pecl.php.net/get/xdiff-2.0.1.tgz && \
tar zxf xdiff-2.0.1.tgz &&  cd xdiff-2.0.1 && \
phpize && ./configure --with-php-config=${PHP_COMPILE_PATH} && \
make && make install && echo 'extension=xdiff.so' >> ${PHP_INI_PATH}

RUN cd ${SRC_PATH} && rm -rf xdiff-2.0.1.tgz xdiff-2.0.1 \
libxdiff-0.23.tar.gz libxdiff-0.23 \
trie_filter-master.zip trie_filter-master

RUN cd ${SRC_PATH} && tar zxf libxdiff-0.23.tar.gz && \
cd libxdiff-0.23 && \
./configure && make && make install

RUN cd ${SRC_PATH} && wget https://pecl.php.net/get/xdiff-2.0.1.tgz && \
tar zxf xdiff-2.0.1.tgz &&  cd xdiff-2.0.1 && \
phpize && ./configure --with-php-config=${PHP_COMPILE_PATH} && \
make && make install && echo 'extension=xdiff.so' >> ${PHP_INI_PATH}

RUN rm -rf libdatrie-0.2.4 libdatrie-0.2.4.tar.gz \
libxdiff-0.23 libxdiff-0.23.tar.gz \
mongodb-1.5.3 mongodb-1.5.3.tgz \
redis-4.2.0 redis-4.2.0.tgz \
swoole-4.2.11 swoole-4.2.11.tgz \
trie_filter-master trie_filter-master.zip \
xdiff-2.0.1 xdiff-2.0.1.tgz \
yaf-3.0.7 yaf-3.0.7.tgz

# +----------------------------------------------------------------------
# | 安装grpc 需要升级gcc 7.3
# +----------------------------------------------------------------------
# + yum -y install centos-release-scl 
# +----------------------------------------------------------------------
# | yum -y install devtoolset-7-gcc devtoolset-7-gcc-c++ devtoolset-7-binutils
# +----------------------------------------------------------------------
# | scl enable devtoolset-7 bash
# +----------------------------------------------------------------------


# +----------------------------------------------------------------------
# | grpc-1.50.0 
# +----------------------------------------------------------------------
# | protobuf-3.21.9
# +----------------------------------------------------------------------

RUN cd ${SRC_PATH} && wget https://pecl.php.net/get/grpc-1.50.0.tgz && \
tar zxf grpc-1.50.0.tgz && cd grpc-1.50.0 && \
phpize && ./configure --with-php-config=${PHP_COMPILE_PATH} && \
make && make install && echo 'extension=grpc.so' >> ${PHP_INI_PATH}

# protobuf
RUN cd ${SRC_PATH} && wget https://pecl.php.net/get/protobuf-3.21.9.tgz && \
tar zxf protobuf-3.21.9.tgz && cd protobuf-3.21.9 
phpize && ./configure --with-php-config=${PHP_COMPILE_PATH} && \
make && make install && echo 'extension=protobuf.so' >> ${PHP_INI_PATH}

RUN cd ${SRC_PATH} && rm -rf grpc-1.50.0.tgz grpc-1.50.0 \
protobuf-3.21.9.tgz protobuf-3.21.9

# 写入启动脚本
RUN echo "php-fpm && tail -f /dev/null" > /root/run.sh  && rm -rf /usr/local/src/ 
CMD ["/bin/bash","/root/run.sh"]

EXPOSE 80
EXPOSE 443
EXPOSE 9000