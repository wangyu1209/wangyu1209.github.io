---
title: Hexo备份及恢复
copyrighr: true
date: 2024-04-01 22:50:49
tags:
  - Centos
  - Linux
  - Mysql
categories:
 - 常用服务安装
---

# Confluence迁移恢复

> **1.备份**

备份方案：

- 使用程序自带每日备份功能
- 备份Confluence主目录及数据库

**使用程序自带每日备份功能**

默认情况下，每天凌晨2：00进行自动备份。

可编辑confluence.cfg.xml配置文件找到以下内容将false改为true，实现自定义备份文件存储路径。更改完重启Confluence服务生效。

```
<property name="admin.ui.allow.daily.backup.custom.location">true</property>
```

> 更多有关自动备份功能可参数官方文档：https://confluence.atlassian.com/conf713/configuring-backups-1077914468.html#ConfiguringBackups-EnablingBackupPathConfiguration

**备份Confluence主目录及数据库**

备份Confluence主目录及数据库（此处示例使用postgresql及Mysql)

postgresql数据库及Confluence主目录备份脚本

```
vim ~/.pgpass
host:port:user:database:password   #模板格式
例如：
127.0.0.1:5432:confluence:confluence:123456   #此内容根据时间情况进行填写保证格式和模板一致即可
chmod 600  ~/.pgpass 
```

`vim /usr/local/wiki_backup.sh ` #写入以下脚本内容

```
#!/bin/bash

# 备份confluence主目录
DATA_PATH=/var/atlassian/application-data/confluence/

# 设置要备份的数据库名称
DB_NAME="confluence"

# 设置要连接的数据库服务器的主机名或 IP 地址
DB_HOST="127.0.0.1"

# 设置要连接的数据库的用户名
DB_USER="confluence"

# 设置备份文件保存的目录
BACKUP_DIR="/data/backup"

# 生成备份文件名（以当前日期命名）
BACKUP_FILE="$BACKUP_DIR/$DB_NAME.sql"
BCKUP_DATA_HOME="$BACKUP_DIR/confluence-data.tar.gz"

# 使用 pg_dump 备份数据库
/usr/pgsql-13/bin/pg_dump -h $DB_HOST -U $DB_USER -F p $DB_NAME > $BACKUP_FILE

# 备份主目录
tar -cf $BACKUP_DATA_HOME -C $DATA_PATH .

# 检查备份是否成功
if [ $? -eq 0 ]; then
  echo "数据库及主目录备份成功，备份文件为: $BACKUP_FILE $BACKUP_DATA_HOME"
else
  echo "数据库及主目录备份失败"
fi
```

Mysql数据库及Confluence主目录备份脚本

```
#!/bin/bash

# 备份confluence主目录
DATA_PATH=/var/atlassian/application-data/confluence/

# 设置要备份的数据库名称
DB_NAME="confluence"

# 设置数据库登录密码
DB_PASSWD="confluence"

# 设置要连接的数据库的用户名
DB_USER="confluence"

# 设置备份文件保存的目录
BACKUP_DIR="/data/backup"

# 生成备份文件名（以当前日期命名）
BACKUP_FILE="$BACKUP_DIR/$DB_NAME.sql"
BCKUP_DATA_HOME="$BACKUP_DIR/confluence-data.tar.gz"

# 使用 mysqldump备份数据库
mysqldump -u$DB_USER -p$DB_PASSWD $DB_NAME > $BACKUP_FILE

# 备份主目录
tar -cf $BACKUP_DATA_HOME -C $DATA_PATH .

# 检查备份是否成功
if [ $? -eq 0 ]; then
  echo "数据库及主目录备份成功，备份文件为: $BACKUP_FILE $BACKUP_DATA_HOME"
else
  echo "数据库及主目录备份失败"
fi
```

将备份脚本加入定时任务，每天凌晨12点开始备份。

`echo "0 0 * * * /usr/local/wiki_backup.sh >> /var/log/pgback.log 2>&1" >> /var/spool/cron/root` 添加定时任务

>  **2.恢复**

可参考链接：https://confluence.atlassian.com/doc/migrating-confluence-between-servers-184150.html

恢复方案

- 使用程序自带每日备份功能恢复
- 使用备份Confluence主目录及数据库方式恢复

**使用程序自带每日备份功能恢复**

搭建新的Confluence服务(创建新数据库授权即可，无需导入数据库数据），安装完成后选择从备份文件还原站点进行恢复。

将备份文件放入/var/atlassian/application-data/confluence/restore目录下，具体的restore路径根据实际的数据主目录为准（自定义安装数据主目录）

还原完成后Confluence恢复完成。

**使用备份Confluence主目录及数据库方式恢复**

1.关闭旧服务服务，在新机器上新搭建confluence服务（只需进行安装bin程序，需配置agent破解包，安装完成后不要运行）

```
wget https://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-7.13.8-x64.bin
yum install java-1.8.0-openjdk-devel -y
chmod +x atlassian-confluence-7.13.8-x64.bin
./atlassian-confluence-7.13.8-x64.bin  #执行安装程序，安装最后一步不运行服务
wget https://github.com/haxqer/confluence/releases/download/v1.3.3/atlassian-agent.jar
mv atlassian-agent.jar /opt/atlassian/confluence/
#编辑配置文件setenv.sh加入以下环境变量配置
vim /opt/atlassian/confluence/bin/setenv.sh
CATALINA_OPTS="-javaagent:/opt/atlassian/confluence/atlassian-agent.jar ${CATALINA_OPTS}"
```

2.安装创建数据库，导入数据库文件。

3.将备份的Confluence主目录配置文件移动到新服务器的主配置文件目录下(如需更改数据目录可根据实际情况进行修改)

如自定义数据目录路径可以修改文件/opt/atlassian/confluence/confluence/WEB-INF/classes/confluence-init.properties

```
mv confluence-data/* /var/atlassian/application-data/confluence/
```

4.更改Confluence二进制目录及数据主目录属主组

```
chown  -R confluence:confluence /opt/atlassian/confluence/
chown  -R confluence:confluence /var/atlassian/application-data/
```

5.修改/var/atlassian/application-data/confluence/confluence.cfg.xml文件找到以下行将数据库连接地址换成新服务地址并更改登录用户名及密码

```
例如：postgresql的连接地址mysql同理
<property name="hibernate.connection.password">confluence</property>
<property name="hibernate.connection.url">jdbc:postgresql://127.0.0.1:5432/confluence</property>
<property name="hibernate.connection.username">confluence</property>
```

6.配置nginx反向代理

7.修改/opt/atlassian/confluence/conf/server.xml文件，指定服务器地址为新服务器地址。

8.启动Confluence服务

9.使用管理员登录>进入一般配置修改服务器的URL>选择内容索引>重新构建索引>恢复完成。

> 如忘记管理员密码可参考链接重置密码：https://blog.myhappiness.top/2024/03/07/change-confluence-admin-password/

