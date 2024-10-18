# [可选]镜像build阶段参数,可以自定义构建参数
ARG VERSION=1.0
# [必须]基础镜像,建议优先选用alpine-linux版本,体积较小,方便发布
FROM openjdk:8u201-jre-alpine3.9
# [必须]镜像维护人员, 填写开发/维护人员邮箱
LABEL author="shadow.li0327@gmail.com" \
      version=$VERSION \
      description="xxl-job-admin-dm"

# [必须]镜像run阶段环境变量,指定国内TimeZone和其他扩展变量
ENV TZ=Asia/Shanghai \
    JAVA_OPTS=${JAVA_OPTS} \
    DB_URL=${DB_URL} \
    DB_USER=${DB_USER} \
    DB_PASS=${DB_PASS}
# [可选]安装/配置/增加镜像内依赖/软件，比如增加字体
RUN sed -i 's!http://dl-cdn.alpinelinux.org/!https://mirrors.ustc.edu.cn/!g' /etc/apk/repositories
# 增加字体，解决验证码没有字体报空指针问题
#RUN apk --no-cache add ttf-dejavu fontconfig
# [必须]添加程序包,ADD命令自动解压
ADD target/xxl-job-admin-*.jar /opt/data/app.jar
# [必须]数据卷映射,日志/配置必须暴露给宿主机
VOLUME /data/applogs
# [可选]工作目录,为了方便操作容器内对象或者指明软件路径
WORKDIR /opt/data
# [必须]容器公开端口,bridge模式使用,host模式无效
EXPOSE 8080
# [必须]启动应用
CMD java -server -jar ${JAVA_OPTS} \
    /opt/data/app.jar \
    --spring.datasource.url=${DB_URL}\
    --spring.datasource.username=${DB_USER} \
    --spring.datasource.password=${DB_PASS} \