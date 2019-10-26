# huaweicloud_ddns  华为云ddns脚本

## 安装
ubuntu/debian
```
apt-get update
apt-get install wget curl dnsutils openssl cron -y
wget -N --no-check-certificate https://raw.githubusercontent.com/lllvcs/huaweicloud_ddns/master/getid.sh
wget -N --no-check-certificate https://raw.githubusercontent.com/lllvcs/huaweicloud_ddns/master/huaweicloud_ddns.sh
chmod +x ./huaweicloud_ddns.sh
chmod +x ./getid.sh
```

centos
```
yum install wget curl bind-utils openssl cron -y
wget -N --no-check-certificate https://raw.githubusercontent.com/lllvcs/huaweicloud_ddns/master/getid.sh
wget -N --no-check-certificate https://raw.githubusercontent.com/lllvcs/huaweicloud_ddns/master/huaweicloud_ddns.sh
chmod +x ./huaweicloud_ddns.sh
chmod +x ./getid.sh
```

## 首次操作
第一步，先在DNS管理控制台```https://console.huaweicloud.com/dns/```内添加对应域名解析记录

第二步，在```getid.sh```内按照提示填写相应信息。运行```getid.sh```，获取需要解析域名的```ZONE_ID```和```RECORDSET_ID```

第三步，在```huaweicloud_ddns.sh```内填写 ```ZONE_ID``` ```RECORDSET_ID```  ```ACCESS_KEY``` ```ACCESS_SECRET```

第四步，运行```huaweicloud_ddns.sh```，设置定时任务

## 设置定时任务
```
crontab -e
*/1 * * * * bash /root/huaweicloud_ddns.sh
```
