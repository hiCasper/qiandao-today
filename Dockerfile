# 基础镜像
FROM python:3.8-slim

# 维护者信息
LABEL maintainer "a76yyyy <q981331502@163.com>"
LABEL org.opencontainers.image.source=https://github.com/qiandao-today/qiandao

# 签到版本 20220203
# 集成皮蛋0.1.1  https://github.com/cdpidan/qiandaor
# 加入蓝调主题 20190118 https://www.quchao.net/QianDao-Theme.html
# --------------
# 基于以上镜像修改了：1、时区设置为上海 2、修改了链接限制 3、加入了send2推送
# 20210112 添加git模块，实现重启后自动更新镜像
# 20210628 使用gitee作为代码源，添加密钥用于更新
# 20210728 更换python版本为python3.8,默认包含redis
# 20220203 更换alpine分支为edge,更换python版本为python3.10
# 20220223 简化构建过程

# Qiandao
ADD . /usr/src/app
WORKDIR /usr/src/app

# Environments
ENV PYCURL_SSL_LIBRARY=openssl
RUN apt update && \
  apt install -y --no-install-recommends libssl-dev libcurl4-openssl-dev build-essential --no-install-recommends && \
  pip install --no-cache-dir -r requirements.txt && \
  pip uninstall -y opencv-python && \
  pip install --no-cache-dir --force-reinstall --no-deps opencv-python-headless && \
  apt autoremove -y build-essential && apt clean

ENV PORT 80
EXPOSE $PORT/tcp

# timezone
ENV TZ=CST-8

# 添加挂载点
VOLUME ["/usr/src/app/","/data"]

CMD ["python","/usr/src/app/run.py"]