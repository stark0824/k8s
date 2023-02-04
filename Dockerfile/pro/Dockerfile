# docker build -t php-fpm72:v2.1_trie -f centos7_phpfpm72_pro .

FROM php-fpm72:v1.0_pure

# 安装编译工具
RUN yum install autoconf g++ gcc make openssl-dev libzip libzip-dev linux-headers

WORKDIR /package/

COPY . .

# libdatrie
#RUN tar zxvf /package/libdatrie-0.2.4.tar.gz && cd libdatrie-0.2.4 make clean && ./configure --prefix=/usr/local/libdatrie && make && make install

#RUN echo "libdatrie Dnoe!!!!!!!!"

# trie_filter
# wget https://github.com/jiopuud/trie_filter/archive/master.zip 

# RUN yum install -y unzip  && wget https://github.com/jiopuud/trie_filter/archive/master.zip  && unzip /package/master.zip 

# RUN cd /package/trie_filter-master && phpize && ./configure --with-php-config=/usr/local/php7/bin/php-config --with-trie_filter=/usr/local/libdatrie && echo 'extension=trie_filter.so' >> /usr/local/php7/lib/php.ini 

# 更改时区
RUN yum install tzdata && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime