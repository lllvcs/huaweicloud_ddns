# huaweicloud_ddns  华为云ddns脚本
## 重要提示！
## 本项目有大量修改更新，请确认能自主获取到```ZONE_ID```和```RECORDSET_ID```后再下载使用
  
## 本脚本适用于ipv4和ipv6地址的更新，请根据需求选择对应文件
## 请调整```sed```的行数，以适应于主机网卡ip地址的获取
## 请确认服务器的地域，并合适选择```EndPoint```、```IAM```与```DNS```地址
  
## 安装
Ubuntu/Debian
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
  
Centos
```
yum install wget curl bind-utils net-tools cron -y
wget -N --no-check-certificate https://raw.githubusercontent.com/lllvcs/huaweicloud_ddns/master/huaweicloud_ddns.sh
OR
wget -N --no-check-certificate https://cdn.jsdelivr.net/gh/lllvcs/huaweicloud_ddns@master/huaweicloud_ddns.sh
OR
wget -N --no-check-certificate https://gitee.com/lvcs/huaweicloud_ddns/raw/master/huaweicloud_ddns.sh
chmod +x ./huaweicloud_ddns.sh
```
  
## 首次操作
第一步，先在DNS管理控制台```https://console.huaweicloud.com/dns/```内添加对应域名解析记录，并获取对应记录的```ZONE_ID```和```RECORDSET_ID```信息

第二步，在```huaweicloud_ddns.sh```内填写 ```账号信息```、```各ID信息```和```ip地址获取的相关参数```

第三步，运行```huaweicloud_ddns.sh```，(可选)设置定时任务
  
## 设置定时任务
```
crontab -e
* * * * * bash ~/huaweicloud_ddns.sh
```
  
## 一点说明
华为云目前虽然支持AK/SK调用API进行域名更新，但是在获取```Zone_ID```和```Record_ID```时需要有一个```X-Auth-Token```头的请求，而目前只能通过用户名、账户名和密码三者来获取```X-Auth-Token```，通过AK/SK获取```X-Auth-Token```目前只在华为内部实现，暂不对外开放。
附上获取```Token```的PDF说明文档
