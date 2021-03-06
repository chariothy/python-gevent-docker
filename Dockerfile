# For Tencent DDNS
# @version 1.0

ARG PYVER
FROM python:${PYVER}-slim AS compile-env

RUN apt-get update \
    && apt-get install -y build-essential libffi-dev python-dev libevent-dev \
    && apt-get autoclean

# Install libs
RUN pip install --no-cache-dir --user gevent
# 本地编译时需要加国内代理
#RUN pip install -i https://pypi.tuna.tsinghua.edu.cn/simple --no-cache-dir --user -r ./requirements.txt

FROM python:${PYVER}-slim
LABEL maintainer="chariothy@gmail.com"

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

ARG TARGETPLATFORM
ARG BUILDPLATFORM

LABEL maintainer="chariothy" \
  org.opencontainers.image.created=$BUILD_DATE \
  org.opencontainers.image.url="https://github.com/chariothy/python-gevent-docker.git" \
  org.opencontainers.image.source="https://github.com/chariothy/python-gevent-docker.git" \
  org.opencontainers.image.version=$VERSION \
  org.opencontainers.image.revision=$VCS_REF \
  org.opencontainers.image.vendor="chariothy" \
  org.opencontainers.image.title="python-gevent" \
  org.opencontainers.image.description="Docker for python with gevent" \
  org.opencontainers.image.licenses="MIT"

COPY --from=compile-env /root/.local /root/.local

WORKDIR /usr/src/app

ENV PATH=/root/.local/bin:$PATH
CMD [ "python" ]