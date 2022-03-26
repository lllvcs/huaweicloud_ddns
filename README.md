# huaweicloud_ddns  华为云ddns脚本
# 重要提示！
## 本项目现已有关于```ZONE_ID```和```RECORDSET_ID```获取方法的教程，不再回答任何关于此类问题的issue
## 本脚本适用于ipv4和ipv6地址的更新，请根据需求选择对应文件
## 请调整```sed```的行数，以适应于主机网卡ip地址的获取
## 请确认服务器的地域，并合适选择```EndPoint```、```IAM```与```DNS```地址，避免出现无法正常更新的问题
## ```ipv6_special.sh```为特殊定制脚本，旨在解决在禁用v6解析环境下的ipv6地址同步
# 
# 安装
## Ubuntu/Debian
```
apt-get update
apt-get install wget curl dnsutils net-tools cron -y
wget -N --no-check-certificate https://raw.githubusercontent.com/lllvcs/huaweicloud_ddns/master/huaweicloud_ddns.sh
OR
wget -N --no-check-certificate https://cdn.jsdelivr.net/gh/lllvcs/huaweicloud_ddns@master/huaweicloud_ddns.sh
OR
wget -N --no-check-certificate https://gitee.com/lvcs/huaweicloud_ddns/raw/master/huaweicloud_ddns.sh
chmod +x ./huaweicloud_ddns.sh
```
## Centos
```
yum install wget curl bind-utils net-tools cron -y
wget -N --no-check-certificate https://raw.githubusercontent.com/lllvcs/huaweicloud_ddns/master/huaweicloud_ddns.sh
OR
wget -N --no-check-certificate https://cdn.jsdelivr.net/gh/lllvcs/huaweicloud_ddns@master/huaweicloud_ddns.sh
OR
wget -N --no-check-certificate https://gitee.com/lvcs/huaweicloud_ddns/raw/master/huaweicloud_ddns.sh
chmod +x ./huaweicloud_ddns.sh
```

# 首次操作
## 第一步，先在DNS管理控制台```https://console.huaweicloud.com/dns/```内添加对应域名解析记录
## 第二步,获取对应记录的```ZONE_ID```和```RECORDSET_ID```信息
### 方法一 F12抓包
```
在修改记录集时，点击提交，即可在网络中找到如下图的数据包
在响应结果中即可找到id与zone_id，其中id为RECORDSET_ID、zone_id为ZONE_ID
```
![方法一](https://cdn.jsdelivr.net/gh/lllvcs/huaweicloud_ddns@master/img/1.jpg)
### 方法二 调用API Explorer
```
点击控制台上方的开发工具-API Explorer
可见如下图的页面，选择云解析服务-Record Set管理-ListRecordSets，填写name(即域名 subdomain.domain.com)，点击调试
在响应结果中即可找到id与zone_id，其中id为RECORDSET_ID、zone_id为ZONE_ID
```
![方法二](https://cdn.jsdelivr.net/gh/lllvcs/huaweicloud_ddns@master/img/2.jpg)
## 第三步，在```huaweicloud_ddns.sh```内填写 ```账号信息```、```各ID信息```和```ip地址获取的相关参数```
## 第四步(可选)，运行```huaweicloud_ddns.sh```，设置定时任务

# 设置定时任务(可选)
```
crontab -e
* * * * * bash ~/huaweicloud_ddns.sh
# 此为每分钟更新一次
```

# 一点说明
华为云目前虽然支持AK/SK调用API进行域名更新，但是在获取```Zone_ID```和```Record_ID```时需要有一个```X-Auth-Token```头的请求，而目前只能通过用户名、账户名和密码三者来获取```X-Auth-Token```，通过AK/SK获取```X-Auth-Token```目前只在华为内部实现，暂不对外开放。

附上获取```Token```的PDF说明文档