FROM debian:wheezy

ENV DEBIAN_FRONTEND noninteractive
ENV DOCKER_VERSION 1.5.0

RUN set -x \
    && apt-get update -qq \
    && apt-get install -qq --no-install-recommends curl ca-certificates python \
    && ( curl -sSL https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz | tar -xzf - ) \
    && google-cloud-sdk/install.sh \
      --usage-reporting=false \
      --rc-path=/.bashrc \
      --bash-completion=false \
      --path-update=true \
      --additional-components=preview \
    && google-cloud-sdk/bin/gcloud components update \
    && mkdir /.ssh \
    && ( curl -sSL https://get.docker.com/builds/Linux/x86_64/docker-${DOCKER_VERSION}.tgz | \
      tar -xzf - -C /usr/bin --strip-components=3 ) \
    && chmod +x /usr/bin/docker \
    && apt-get remove -qq --auto-remove curl \
    && apt-get clean -qq \
    && rm -rf /var/lib/apt/lists/*

ENV PATH /google-cloud-sdk/bin:$PATH
ENV HOME /

VOLUME ["/.config"]

CMD ["/bin/bash"]
