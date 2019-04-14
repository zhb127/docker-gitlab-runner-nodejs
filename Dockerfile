# https://docs.gitlab.com/runner/install/docker.html#docker-images
FROM gitlab/gitlab-runner:latest

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && sed -i s/security.ubuntu.com/mirrors.aliyun.com/g /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y nodejs \
    && npm config set registry 'https://registry.npm.taobao.org' -g \
    && npm install -g pm2