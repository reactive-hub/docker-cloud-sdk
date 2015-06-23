FROM debian:jessie

ENV DEBIAN_FRONTEND noninteractive

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
    && google-cloud-sdk/bin/gcloud --quiet components update beta \
    && google-cloud-sdk/bin/gcloud --quiet config set component_manager/disable_update_check true \
    && mkdir /.ssh \
    && apt-get remove -qq --auto-remove curl \
    && apt-get clean -qq \
    && rm -rf /var/lib/apt/lists/*

ENV PATH /google-cloud-sdk/bin:$PATH
ENV HOME /

VOLUME ["/.config"]

CMD ["/bin/bash"]
