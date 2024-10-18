# 2.4.2
- 适配dm8数据库并引入对应的jdbc包 
> (COMPATIBLE_ MODE = 4 Oracle兼容模式)
> 
> (COMPATIBLE_ MODE = 2 Mysql兼容模式) 本项目不涉及,建议使用原版
- 适配linux/arm64 
- 添加达梦数据库初始化脚本 tables_xxl_job_dm.sql
- 删除相关example示例,适配用不上
- 增加build.sh的docker镜像构建脚本, 需要安装xmllint或者手动打包