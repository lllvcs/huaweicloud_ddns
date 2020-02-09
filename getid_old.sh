#!/bin/bash
stty erase ^h
# Author LVCS
# https://github.com/lllvcs/huaweicloud_ddns
#在运行此脚本之前，请先在DNS管理控制台内添加对应域名记录！
#Please add the corresponding domain name record in the DNS management console before running this script!

#请填写用户名、密码和账户名(一般来说个人账户用户名和账户名相同)
#Please fill in the username, password and account name
username="your_username"
password="your_password"
accountname="your_organization's_account_name"

#请填写域名和主机名
#Please fill in the domain name and host name
domain="your_domain"
host="your_domain's_host"

token_X="$(curl -L -k -s -D - -o /dev/null  -X POST \
  "https://iam.myhuaweicloud.com/v3/auth/tokens" \
  -H 'content-type: application/json' \
  -d '{
    "auth": {
        "identity": {
            "methods": ["password"],
            "password": {
                "user": {
                    "name": "'$username'",
                    "password": "'$password'",
                    "domain": {
                        "name": "'$accountname'"
                    }
                }
            }
        },
        "scope": {
            "domain": {
                "name": "'$accountname'"
            }
        }
    }
  }' | grep X-Subject-Token
  )"

token="$(echo $token_X | awk -F ' ' '{print $2}')"

#Zone_ID_RAW="$(curl -L -k -s -X GET \
#  https://dns.myhuaweicloud.com/v2/zones?name=$domain. \
#  -H 'content-type: application/json' \
#  -H 'X-Auth-Token: '$token)"

#Zone_ID="$(echo $Zone_ID_RAW|grep -Eo "\"id\":\"[0-9a-z]*\",\"name\":\"$domain.\",\"description\""|grep -o "id\":\"[0-9a-z]*\""| awk -F : '{print $2}'|grep -o "[a-z0-9]*")"

recordsets="$(curl -L -k -s -D - -o /dev/null GET \
  "https://dns.myhuaweicloud.com/v2.1/recordsets?name=$host.$domain." \
  -H 'content-type: application/json' \
  -H 'X-Auth-Token: '$token | grep -o "id\":\"[0-9a-z]*\""| awk -F : '{print $2}'|grep -o "[a-z0-9]*"
  )"

#echo $token
echo -e "\033[1;41;37m 第一个为RECORDSET_ID，第二个为ZONE_ID，第三个为PROJECT_ID(不用管) \033[0m" 
echo -e "\033[1;41;37m 若输入数据有误，仅会返回REQUEST_ID 或空值 \033[0m" 
echo -e "\033[1;41;37m The FRIST one is RECORDSET_ID, the SECOND is ZONE_ID, and the LAST is PROJECT_ID \033[0m" 
echo -e "\033[1;33m$recordsets\033[0m"  