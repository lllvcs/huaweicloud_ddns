# huaweicloud_ddns  华为云ddns脚本 CNAME版

## 本脚本仅适用于CNAME地址的更新，适合于一些特殊场景使用
## 普通DDNS功能请查看master分支
## 网卡地址获取仅适用于Debian9+/Ubuntu18+（旧版本网卡地址获取请参考old分支）
## 选择网卡获取ipv4地址时，请确认代码第98行处sed的行数
## 请确认服务器的地域，并合适选择EndPoint地址

## 安装
Ubuntu/Debian
```
apt-get update
apt-get install wget curl dnsutils cron -y
wget -N --no-check-certificate https://raw.githubusercontent.com/lllvcs/huaweicloud_ddns/cname/huaweicloud_ddns_cname.sh
OR
wget -N --no-check-certificate https://cdn.jsdelivr.net/gh/lllvcs/huaweicloud_ddns@cname/huaweicloud_ddns_cname.sh
OR
wget -N --no-check-certificate https://gitee.com/lvcs/huaweicloud_ddns/raw/cname/huaweicloud_ddns_cname.sh
chmod +x ./huaweicloud_ddns.sh
```

Centos
```
yum install wget curl bind-utils cron -y
wget -N --no-check-certificate https://raw.githubusercontent.com/lllvcs/huaweicloud_ddns/cname/huaweicloud_ddns_cname.sh
OR
wget -N --no-check-certificate https://cdn.jsdelivr.net/gh/lllvcs/huaweicloud_ddns@cname/huaweicloud_ddns_cname.sh
OR
wget -N --no-check-certificate https://gitee.com/lvcs/huaweicloud_ddns/raw/cname/huaweicloud_ddns.sh
chmod +x ./huaweicloud_ddns_cname.sh
```

## 首次操作
第一步，先在DNS管理控制台```https://console.huaweicloud.com/dns/```内添加对应域名CNAME解析记录

第二步，在```huaweicloud_ddns_cname.sh```内填写 ```账号信息``` ```域名信息```

第三步，运行```huaweicloud_ddns_cname.sh```，设置定时任务

## 设置定时任务
```
crontab -e
* * * * * bash /root/huaweicloud_ddns_cname.sh
```

## 一点说明
华为云目前虽然支持AK/SK调用API进行域名更新，但是在获取```Zone_ID```和```Record_ID```时需要有一个```X-Auth-Token```头的请求，而目前只能通过用户名、账户名和密码三者来获取```X-Auth-Token```，通过AK/SK获取```X-Auth-Token```目前只在华为内部实现，暂不对外开放。
附上获取```Token```的PDF说明文档
