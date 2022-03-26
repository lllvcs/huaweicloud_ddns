#!/bin/bash
# Copyright 2022 LVCS
# https://github.com/lllvcs/huaweicloud_ddns
# https://gitee.com/lvcs/huaweicloud_ddns
# 此为特殊定制脚本，旨在解决在禁用ipv6解析环境下的ipv6地址同步
# 在运行此脚本之前，请先在华为云DNS管理控制台内添加对应域名的A记录
# 并获取对应的 ZONE_ID 和 RECORDSET_ID

# 一般来说用户名和账户名相同
USERNAME=""
ACCOUNTNAME=""
PASSWORD=""

# 对应解析记录的 ZONE_ID 和 RECORDSET_ID
ZONE_ID=""
RECORDSET_ID=""

# 从外网API获取ip地址(默认开启1)
REMOTE_RESOLVE=1

# 从网卡获取ip地址(填写网卡名)
# 并请根据实际情况填写sed行数
INTERFACE=""

# 获取ip地址网址
GETIPURL="api.ip.sb"
#GETIPURL="api.ip.gs"
#GETIPURL="api.myip.la"
#GETIPURL="api6.ipify.org"

# HTTPDNS地址
HTTPDNS=$(curl -s "https://dns.alidns.com/resolve?name=$GETIPURL&type=AAAA" | grep -oE '(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))' | head -1)

# End Point 终端地址 请根据地域选择，默认为北京1
IAM="iam.myhuaweicloud.com"
#IAM="iam.cn-north-4.myhuaweicloud.com"
#IAM="iam.cn-east-2.myhuaweicloud.com"
#IAM="iam.cn-east-3.myhuaweicloud.com"
#IAM="iam.cn-south-1.myhuaweicloud.com"
#IAM="iam.cn-southwest-2.myhuaweicloud.com"
#IAM="iam.ap-southeast-1.myhuaweicloud.com"
#IAM="iam.ap-southeast-2.myhuaweicloud.com"
#IAM="iam.ap-southeast-3.myhuaweicloud.com"
#IAM="iam.af-south-1.myhuaweicloud.com"

DNS="dns.myhuaweicloud.com"
#DNS="dns.cn-north-4.myhuaweicloud.com"
#DNS="dns.cn-east-2.myhuaweicloud.com"
#DNS="dns.cn-east-3.myhuaweicloud.com"
#DNS="dns.cn-south-1.myhuaweicloud.com"
#DNS="dns.cn-southwest-2.myhuaweicloud.com"
#DNS="dns.ap-southeast-1.myhuaweicloud.com"
#DNS="dns.ap-southeast-2.myhuaweicloud.com"
#DNS="dns.ap-southeast-3.myhuaweicloud.com"
#DNS="dns.af-south-1.myhuaweicloud.com"

# 更新IP
TARGET_IP=""

TOKEN_X="$(
    curl -L -k -s -D - -X POST \
        "https://$IAM/v3/auth/tokens" \
        -H 'content-type: application/json' \
        -d '{
    "auth": {
        "identity": {
            "methods": ["password"],
            "password": {
                "user": {
                    "name": "'$USERNAME'",
                    "password": "'$PASSWORD'",
                    "domain": {
                        "name": "'$ACCOUNTNAME'"
                    }
                }
            }
        },
        "scope": {
            "domain": {
                "name": "'$ACCOUNTNAME'"
            }
        }
    }
  }' | grep X-Subject-Token
)"

TOKEN="$(echo $TOKEN_X | awk -F ' ' '{print $2}')"

if [ -z $TARGET_IP ]; then
    if [ $REMOTE_RESOLVE -eq 1 ]; then
        if [ $INTERFACE ]; then
            TARGET_IP=$(curl -s --interface $INTERFACE [$HTTPDNS] -H "Host:$GETIPURL")
        else
            TARGET_IP=$(curl -s [$HTTPDNS] -H "Host:$GETIPURL")
        fi
    else
        if [ $INTERFACE ]; then
            TARGET_IP=$(ifconfig $INTERFACE | grep 'inet6 ' | grep -oE '(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))' | sed -n 1p)
        else
            TARGET_IP=$(ifconfig | grep 'inet6 ' | grep -oE '(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9]))' | sed -n 1p)
        fi
    fi
fi

curl -X PUT -L -k -s \
    "https://$DNS/v2/zones/$ZONE_ID/recordsets/$RECORDSET_ID" \
    -H "Content-Type: application/json" \
    -H "X-Auth-Token: $TOKEN" \
    -d "{\"records\": [\"$TARGET_IP\"],\"ttl\": 1}"
