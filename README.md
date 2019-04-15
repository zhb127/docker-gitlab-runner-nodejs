# Gitlab-runner Nodejs 镜像

> 使用基础镜像：[gitlab/gitlab-runner:latest](https://docs.gitlab.com/runner/install/docker.html#docker-images)

## 环境说明

- ubuntu 16.04
    - apt-get
        - mirror: http://mirrors.aliyun.com/ubuntu/
- nodejs8
    - npm
        - registry: taobao
    - pm2

> 为了优化网络请求速度，本容器镜像已将其系统环境中相应的软件源替换为[阿里云镜像](https://mirrors.aliyun.com/about)。

## 使用说明

### 注册 gitlab-runner

执行以下命令，在完成一系列交互操作后，注册一个 gitlab-runner，同时，将配置文件保存到主机 `$(pwd)/config` 目录下：

```bash
docker run --rm -it -v $(pwd)/config:/etc/gitlab-runner gitlab/gitlab-runner register
```

### 运行 gitlab-runner

这里直接使用 docker-compose 来运行：

```yaml
version: "3"
services:
  gitlab-runner:
    image: gitlab/gitlab-runner
    container_name: your-gitlab-runner
    restart: always
    network_mode: host
    volumes:
      - "./config:/etc/gitlab-runner"
```

## 一些场景

### 在 gitlab-runner 中使用 ssh keys

> 当前容器镜像暂不支持配置默认 ssh key，目前方案是在 .gitlab-ci.yml 文件中，通过before_script 来动态添加 ssh key。

```yaml
before_script:
  - 'which ssh-agent || ( apt-get update -y && apt-get install openssh-client -y )'
  - eval $(ssh-agent -s)
  - echo "$SSH_PRIVATE_KEY" | tr -d '\r' | ssh-add - > /dev/null
  - mkdir -p ~/.ssh
  - chmod 700 ~/.ssh
  - ssh-keyscan "$SSH_KNOWN_HOST"
```

## 参考文档

- [https://docs.gitlab.com/runner/install/docker.html](https://docs.gitlab.com/runner/install/docker.html)
- [https://docs.gitlab.com/ee/ci/ssh_keys/](https://docs.gitlab.com/ee/ci/ssh_keys/)