#docker build -t php-fpm:k8s_v2.x -f k8s_v2.x .

FROM php-fpm:k8s_v1.x

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

# 安装最新版本的GCC
# RUN yum -y install centos-release-scl && yum -y install devtoolset-9-gcc devtoolset-9-gcc-c++ devtoolset-9-binutils && scl enable devtoolset-9 bash && echo "source /opt/rh/devtoolset-9/enable" >> /etc/profile 

RUN tar zxf /usr/local/src/grpc-1.50.0.tgz &&  cd /usr/local/src/grpc-1.50.0 && \
phpize && ./configure --with-php-config=/usr/local/php7/bin/php-config && \
make && make install && echo 'extension=grpc.so' >> /usr/local/php7/lib/php.ini

RUN tar zxf /usr/local/src/protobuf-3.21.9.tgz &&  cd /usr/local/src/protobuf-3.21.9 && \
phpize && ./configure --with-php-config=/usr/local/php7/bin/php-config && \
make && make install && echo 'extension=protobuf.so' >> /usr/local/php7/lib/php.ini

# 写入启动脚本
# RUN echo "php-fpm && tail -f /dev/null" > /root/run.sh  && rm -rf /usr/local/src/ 
# CMD ["/bin/bash","/root/run.sh"]

EXPOSE 80
EXPOSE 443
EXPOSE 9000

