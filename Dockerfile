# 基础镜像
FROM python:3.8-slim

# Qiandao
WORKDIR /usr/src/app

# Environments
ENV PYCURL_SSL_LIBRARY=openssl
RUN apt update && \
  apt install -y --no-install-recommends git libssl-dev libcurl4-openssl-dev build-essential --no-install-recommends && \
  git clone --depth 1 https://github.com/qiandao-today/qiandao.git . && \
  sed -i '/==/!d' requirements.txt && \
  sed -i 's/# //' requirements.txt && \
  pip install --no-cache-dir -r requirements.txt && \
  pip uninstall -y opencv-python && \
  pip install --no-cache-dir --force-reinstall --no-deps opencv-python-headless && \
  rm -rf .git && \
  apt autoremove -y git build-essential && apt clean

ENV PORT 80
EXPOSE $PORT/tcp

# timezone
ENV TZ=CST-8

# 添加挂载点
VOLUME ["/usr/src/app/"]

CMD ["python","/usr/src/app/run.py"]