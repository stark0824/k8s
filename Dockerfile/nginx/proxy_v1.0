# +----------------------------------------------------------------------
# | Author:Stark
# +----------------------------------------------------------------------
# | Date:2023/02/08
# +----------------------------------------------------------------------
# | Desc: Nginx https://nginx.org/download/nginx-1.20.2.tar.gz
# +----------------------------------------------------------------------
# | Desc: Nginx 纯版镜像
# +----------------------------------------------------------------------
# | Shell: docker build -t nginx:proxy_v1.x_mini -f proxy_v1.0 .
# +----------------------------------------------------------------------

FROM centos:centos7

ENV SRC_PATH /usr/local/src/

WORKDIR /usr/local/src/ 

RUN yum -y update && yum install -y gcc gcc-c++ wget tree pcre-devel zlib-devel \
openssl openssl-devel libxml2 libxml2-dev libxslt-devel gd-devel \
ncurses-devel perl perl-ExtUtils-Embed gperftools


RUN cd ${SRC_PATH} && wget https://nginx.org/download/nginx-1.20.2.tar.gz && \
tar zxf nginx-1.20.2.tar.gz && cd nginx-1.20.2

RUN cd ${SRC_PATH}/nginx-1.20.2 && \
./configure --prefix=/usr/local/nginx \ 
--with-compat --with-debug \
--with-file-aio --with-google_perftools_module \
--with-http_addition_module --with-http_auth_request_module \
--with-http_dav_module --with-http_degradation_module  \
--with-http_flv_module --with-http_gunzip_module \
--with-http_gzip_static_module  \
--with-http_image_filter_module=dynamic --with-http_mp4_module \
--with-http_perl_module=dynamic --with-http_random_index_module \
--with-http_realip_module --with-http_secure_link_module  \
--with-http_slice_module --with-http_ssl_module  \
--with-http_stub_status_module --with-http_sub_module \
--with-http_v2_module --with-http_xslt_module=dynamic  \
--with-mail=dynamic --with-mail_ssl_module --with-pcre  \
--with-pcre-jit --with-stream=dynamic --with-stream_ssl_module  \
--with-stream_ssl_preread_module \
--with-threads --with-cc-opt='-O2 -g -pipe -Wall \
-Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector-strong \
--param=ssp-buffer-size=4 \ 
-grecord-gcc-switches -m64 -mtune=generic -fPIC' \
--with-ld-opt='-Wl,-z,relro -Wl,-z,now -pie' \
&& make && make install 

RUN ln -s /usr/local/nginx/sbin/nginx /usr/local/bin/nginx 

EXPOSE 80
EXPOSE 443

