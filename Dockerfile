# For Tencent DDNS
# @version 1.0

FROM python:3.8-slim AS build-env
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
  org.opencontainers.image.title="python-gevent-docker" \
  org.opencontainers.image.description="python with gevent" \
  org.opencontainers.image.licenses="MIT"

# Install libs
RUN pip install --no-cache-dir gevent
# 本地编译时需要加国内代理
#RUN pip install -i https://pypi.tuna.tsinghua.edu.cn/simple --no-cache-dir -r ./requirements.txt

FROM python:3.8-slim
COPY --from=build-env /usr/local/lib/python3.8/site-packages/greenlet.so /usr/local/lib/python3.8/site-packages/
COPY --from=build-env /usr/local/lib/python3.8/site-packages/gevent/ /usr/local/lib/python3.8/site-packages/gevent/

CMD [ "python" ]