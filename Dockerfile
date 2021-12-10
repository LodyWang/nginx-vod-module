FROM alpine:3.12.0 AS base_image

FROM base_image AS build

RUN apk add --no-cache curl build-base openssl openssl-dev zlib-dev linux-headers pcre-dev ffmpeg ffmpeg-dev
RUN mkdir nginx nginx-vod-module nginx-aws-auth-module nginx-secure-token-module nginx-akamai-token-validate-module

ARG NGINX_VERSION=1.16.1

RUN curl -sL https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz | tar -C /nginx --strip 1 -xz
RUN curl -sL https://github.com/kaltura/nginx-vod-module/archive/master.tar.gz | tar -C /nginx-vod-module --strip 1 -xz
RUN curl -sL https://github.com/kaltura/nginx-aws-auth-module/archive/master.tar.gz | tar -C /nginx-aws-auth-module --strip 1 -xz
RUN curl -sL https://github.com/kaltura/nginx-secure-token-module/archive/master.tar.gz | tar -C /nginx-secure-token-module --strip 1 -xz
RUN curl -sL https://github.com/kaltura/nginx-akamai-token-validate-module/archive/master.tar.gz | tar -C /nginx-akamai-token-validate-module --strip 1 -xz

WORKDIR /nginx
RUN ./configure --prefix=/usr/local/nginx \
	--add-module=../nginx-vod-module \
        --add-module=../nginx-aws-auth-module \
	--with-http_ssl_module \
	--with-file-aio \
	--with-threads \
	--with-cc-opt="-O3"
RUN make
RUN make install
RUN rm -rf /usr/local/nginx/html /usr/local/nginx/conf/*.default

FROM base_image
RUN apk add --no-cache ca-certificates openssl pcre zlib ffmpeg
COPY --from=build /usr/local/nginx /usr/local/nginx
ENTRYPOINT ["/usr/local/nginx/sbin/nginx"]
CMD ["-g", "daemon off;"]
