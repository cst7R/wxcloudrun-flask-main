#
# 选择基础镜像。如需更换，请到[dockerhub官方仓库](https://hub.docker.com/_/python?tab=tags)自行选择后替换。
FROM ubuntu:20.04

RUN  sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list
RUN  apt-get clean

# 更新软件包列表并安装ca-certificates
RUN apt-get update \
&& DEBIAN_FRONTEND=noninteractive apt-get install -y ca-certificates \
&& rm -rf /var/lib/apt/lists/*

# 更新软件包列表并安装Python3和pip
RUN apt-get update \
&& DEBIAN_FRONTEND=noninteractive apt-get install -y python3 python3-pip \
&& rm -rf /var/lib/apt/lists/*

# 拷贝当前项目到/app目录下（.dockerignore中文件除外）
COPY . /app

# 设定当前的工作目录
WORKDIR /app

RUN pip3 config set global.index-url http://mirrors.aliyun.com/pypi/simple
RUN pip3 config set install.trusted-host mirrors.aliyun.com
RUN pip3 install pip -U
# 安装依赖包
RUN pip3 install -r requirements.txt

# 暴露端口
# 此处端口必须与「服务设置」-「流水线」以及「手动上传代码包」部署时填写的端口一致，否则会部署失败。
EXPOSE 80

# 执行启动命令
CMD ["python3", "run.py", "0.0.0.0", "80"]