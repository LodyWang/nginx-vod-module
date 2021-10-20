# nginx-vod-module
docker for [kaltura's nginx-vod-module](https://github.com/kaltura/nginx-vod-module),include [kaltura's nginx-aws-auth module](https://github.com/kaltura/nginx-aws-auth-module)
# build locally
docker build -t nginx-vod-module .
# how to use
## local mode
docker run -p 80:80 -v $PWD/videos:/opt/static/videos -v $PWD/nginx.conf:/usr/local/nginx/conf/nginx.conf wlongdoc/nginx-vod-module
## remote mode 
docker run -p 80:80 -v $PWD/nginx.conf:/usr/local/nginx/conf/nginx.conf wlongdoc/nginx-vod-module
# docker hub
[https://hub.docker.com/r/wlongdoc/nginx-vod-module](https://hub.docker.com/r/wlongdoc/nginx-vod-module)
