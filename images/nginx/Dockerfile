FROM phusion/baseimage:

MAINTAINER ivan@lagunovsky.com

ENV DEBIAN_FRONTEND noninteractive

ENV NGINX_VERSION 1.9.9
ENV NPS_VERSION 1.10.33.2
ENV UPM_VERSION 0.9.1
ENV NGINX_USER www-data
ENV SETUP_DIR /var/cache/nginx

RUN rm -rf /etc/apt/sources.list
ADD sources.list /etc/apt/

RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    wget \
    libpcre3-dev \
    zlib1g-dev \
    openssl \
    build-essential \
    zlib1g-dev \
    libssl-dev \
    libgd2-xpm-dev \
    libgeoip-dev \
    --no-install-recommends && rm -rf /var/lib/apt/lists/*

RUN mkdir -p ${SETUP_DIR}

# Prepare module
RUN cd ${SETUP_DIR} \
    && wget https://github.com/pagespeed/ngx_pagespeed/archive/v${NPS_VERSION}-beta.tar.gz --no-check-certificate \
    && tar zxvf v${NPS_VERSION}-beta.tar.gz \
    && cd ngx_pagespeed-${NPS_VERSION}-beta \
    && wget https://dl.google.com/dl/page-speed/psol/${NPS_VERSION}.tar.gz --no-check-certificate \
    && tar -xzvf ${NPS_VERSION}.tar.gz

RUN cd ${SETUP_DIR} \
    && wget https://github.com/masterzen/nginx-upload-progress-module/archive/v${UPM_VERSION}.tar.gz --no-check-certificate \
    && tar zxvf v${UPM_VERSION}.tar.gz

# Install nginx
RUN wget -P ${SETUP_DIR} http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz
RUN tar -zxvf ${SETUP_DIR}/nginx-${NGINX_VERSION}.tar.gz -C ${SETUP_DIR}
RUN cd ${SETUP_DIR}/nginx-${NGINX_VERSION} && ./configure \
    --prefix=/opt/nginx \
    --sbin-path=/usr/sbin/nginx \
    --conf-path=/opt/nginx/nginx.conf \
    --pid-path=/var/run/nginx.pid \
    --lock-path=/var/run/nginx.lock \
    --http-client-body-temp-path=/var/lib/nginx/body \
    --http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
    --http-proxy-temp-path=/var/lib/nginx/proxy \
    --with-http_ssl_module \
    --with-openssl-opt="enable-tlsext" \
    --with-cc=/usr/bin/gcc \
    --with-poll_module \
    --with-select_module \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --with-http_realip_module \
    --with-http_addition_module \
    --with-http_geoip_module \
    --with-http_sub_module \
    --with-http_dav_module \
    --with-http_flv_module \
    --with-http_mp4_module \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_random_index_module \
    --with-http_secure_link_module \
    --with-http_stub_status_module \
    --with-http_auth_request_module \
    --with-mail \
    --with-mail_ssl_module \
    --with-file-aio \
    --with-ipv6 \
    --with-threads \
    --with-stream \
    --with-stream_ssl_module \
    --with-http_slice_module \
    --with-http_v2_module \
    --add-module=${SETUP_DIR}/ngx_pagespeed-${NPS_VERSION}-beta \
    --add-module=${SETUP_DIR}/nginx-upload-progress-module-${UPM_VERSION}

RUN cd ${SETUP_DIR}/nginx-${NGINX_VERSION} && make && make install
RUN nginx -V

RUN apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false \
    gcc \
    g++ \
    wget \
    libpcre3-dev \
    zlib1g-dev \
    openssl \
    build-essential \
    zlib1g-dev \
    libssl-dev \
    libgd2-xpm-dev

RUN apt-get clean all
RUN rm -rf ${SETUP_DIR}/{nginx,ngx_pagespeed}
RUN rm -rf /var/lib/apt/lists/*

COPY config/ /etc/nginx/

RUN mkdir /etc/nginx/sites-enabled/ \
    && mkdir -p /var/lib/nginx/body

ADD scripts/nginx /etc/init.d/nginx
RUN chmod +x /etc/init.d/nginx \
    && update-rc.d nginx defaults

RUN mkdir /usr/share/nginx \
    && ln -sf /opt/nginx/html /usr/share/nginx/html

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

ADD start-nginx /etc/my_init.d/start-nginx.sh
RUN chmod +x  /etc/my_init.d/start-nginx.sh

EXPOSE 80 443