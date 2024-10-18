#!/usr/bin/env bash
# STEP1-准备阶段
## [可选]通过命令读取应用名称
APP_NAME=$(xmllint --xpath '/*[local-name()="project"]/*[local-name()="artifactId"]/text()' pom.xml)
## [可选]通过命令读取应用版本
VERSION=$(xmllint --xpath '/*[local-name()="project"]/*[local-name()="parent"]/*[local-name()="version"]/text()' pom.xml)
## [必须]拼接完整应用名称,可以手动修改或者读取配置拼接
APP_FULL_NAME=${APP_NAME}:${VERSION}
## [可选]私服目标服务器
# REGISTRY=xxx.xxx.xxx
echo "开始构建应用${APP_FULL_NAME}..."
## [可选]应用打包,前端打包npm/yarn,后端打包mvn
cd .. && mvn clean && mvn package && cd ./xxl-job-admin || exit
# STEP2-开始打包
echo "开始构建镜像${APP_FULL_NAME}..."
## [必须]停止并删除本地容器
docker rm "$(docker ps -a -f name=${APP_NAME} -q)"
## [必须]删除本地对应版本镜像
docker rmi "$(docker image ls -f reference=${APP_FULL_NAME} -q)" -f
## [必须]构建镜像,需要注意参数platform,可以指定x86架构或者arm架构
docker build -t "${APP_FULL_NAME}" . --platform=linux/arm64
## [可选]导出docker镜像压缩包
docker save -o "${APP_NAME}.tar" "${APP_FULL_NAME}"
## [可选]镜像私服Tag标记
#docker tag ${APP_FULL_NAME} ${REGISTRY}/${APP_FULL_NAME}
## [可选]推送私服仓库
#ocker push ${REGISTRY}/${APP_FULL_NAME}

# STEP3-本地测试
## [必须]启动容器验证
docker run -p 8080:8080 --name="${APP_NAME}" -e DB_URL=jdbc:dm://192.168.0.101:5236 -e DB_USER=SYSDBA -e DB_PASS=SYSDBA "${APP_FULL_NAME}"
## [可选]停止并删除本地容器
#docker rm "$(docker ps -a -f name=${APP_NAME} -q)"
## [可选]删除本地镜像,节省磁盘空间
#docker rmi "$(docker image ls -f reference=${APP_FULL_NAME} -q)" -f