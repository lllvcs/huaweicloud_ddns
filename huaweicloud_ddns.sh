#!/bin/bash

#ZONE_ID和RECORDSET_ID，分别为域名id和子域id，请通过官方api获取(https://dns.myhuaweicloud.com/v2/zones)
#ACCESS_KEY和ACCESS_SECRET请在我的凭证-访问密钥中生成
#详情请参考官方文档(https://support.huaweicloud.com/api-dns/zh-cn_topic_0132421999.html)

ZONE_ID="ZONE_ID"
RECORDSET_ID="RECORDSET_ID"

ACCESS_KEY="ACCESS_KEY"
ACCESS_SECRET="ACCESS_SECRET"

#从外网api获取ip地址(默认开启)
REMOTE_RESOLVE=1

#或从网卡获取ip地址(填写网卡名)
INTERFACE=""

TARGET_IP=""
#Debug模式(默认关闭)
DEBUG=0

usage() {
cat<<EOF
Usage: 
    ./HuaweiCloud-DDNS.sh --access-key "ACCESS_KEY" --access-secret "ACCESS_SECRET" -z "ZONE-ID" -r "RECORDSET_ID" -i "INTERFACE" -m

    -k|--access-key
    -s|--access-secret
    -z|--zone-id
    -r|--recordset-id
    -i|--interface
    -m|--remote-resolve
    --address <ip address>
    -v|--debug
    -h|--help
EOF
	exit 1; 
}

ARGS=`getopt -o k:s:z:r:i:mvh -l access-key:,access-secret:,zone-id:,recordset-id:,interface:,remote-resolve,debug,help,address: -n HuaweiCloud-DDNS.sh -- "$@"`
if [ $? != 0 ]; then
    usage
    exit 1
fi

eval set -- "$ARGS"

while true; do
	case "$1" in
		-k|--access-key)
			ACCESS_KEY=$2
			shift
			;;
		-s|--access-secret)
			ACCESS_SECRET=$2
			shift
			;;
		-z|--zone-id)
			ZONE_ID=$2
			shift
			;;
        -r|--recordset-id)
            RECORDSET_ID=$2
			shift
			;;
		-i|--interface)
			INTERFACE=$2
			shift
			;;
		-m|--remote-resolve)
			REMOTE_RESOLVE=1
			;;
		--address)
			TARGET_IP=$2
			shift
			;;
		-v|--debug)
			DEBUG=1
			;;
		-h|--help)
			usage
			exit 1
			;;
		--)
			shift
			break
			;;
		*)
			usage
			exit 1
			;;
	esac
shift
done

if [ -z $TARGET_IP ]; then
	if [ $REMOTE_RESOLVE -eq 1 ]; then
		if [ $DEBUG -eq 1 ]; then
			if [ $INTERFACE ]; then
				TARGET_IP=$(curl --interface $INTERFACE http://members.3322.org/dyndns/getip)
			else
				TARGET_IP=$(curl http://members.3322.org/dyndns/getip)
			fi
		else
			if [ $INTERFACE ]; then
				TARGET_IP=$(curl -s --interface $INTERFACE http://members.3322.org/dyndns/getip)
			else
				TARGET_IP=$(curl -s http://members.3322.org/dyndns/getip)
			fi
		fi	
	else
		if [ $INTERFACE ]; then
			TARGET_IP=$(ifconfig $INTERFACE | grep 'inet addr' | awk -F ":" '{print $2}' | awk '{print $1}')
		else
			TARGET_IP=$(ifconfig | grep 'inet addr' | awk -F ":" '{print $2}' | awk '{print $1}' | head -n 1)
		fi
	fi
fi

if [ $DEBUG -eq 1 ]; then
cat<<EOF
HuaweiCloud DDNS script debug info.
    ACCESS KEY: $ACCESS_KEY
 ACCESS SECRET: $ACCESS_SECRET
       ZONE ID: $ZONE_ID
  RECORDSET ID: $RECORDSET_ID
     Interface: $INTERFACE
Remote Resolve: $REMOTE_RESOLVE
    Debug Mode: $DEBUG
EOF
fi

REQUEST_METHOD="PUT"
REQUEST_HOST="dns.myhuaweicloud.com"
REQUEST_PATH="/v2/zones/$ZONE_ID/recordsets/$RECORDSET_ID"
REQUEST_PARAM=""
REQUEST_DATA="{\"records\":[\"$TARGET_IP\"]}"

REQUEST_CONTENT_TYPE='application/json'
REQUEST_TIME=`date -u +%Y%m%dT%H%M%SZ`

REQUEST_DATA_HASH=`echo -ne "$REQUEST_DATA" | openssl dgst -sha256 -hex | grep -Po "([0-9a-f]{64})"`
REQUEST_HEADER="$REQUEST_METHOD\n$REQUEST_PATH/\n$REQUEST_PARAM\ncontent-type:$REQUEST_CONTENT_TYPE\nhost:$REQUEST_HOST\nx-sdk-date:$REQUEST_TIME\n\ncontent-type;host;x-sdk-date"
REQUEST_HASH=`echo -ne "$REQUEST_HEADER\n$REQUEST_DATA_HASH" | openssl dgst -sha256 -hex | grep -Po "([0-9a-f]{64})"`
HMAC=`echo -ne "SDK-HMAC-SHA256\n$REQUEST_TIME\n$REQUEST_HASH" | openssl dgst -sha256 -hmac "$ACCESS_SECRET" -hex | grep -Po "([0-9a-f]{64})"`

if [ $DEBUG -eq 1 ]; then
	curl -X $REQUEST_METHOD "https://$REQUEST_HOST$REQUEST_PATH?$REQUEST_PARAM" -H "Content-Type: $REQUEST_CONTENT_TYPE" -H "X-Sdk-Date: $REQUEST_TIME" -H "host: $REQUEST_HOST" -H "Authorization: SDK-HMAC-SHA256 Access=$ACCESS_KEY, SignedHeaders=content-type;host;x-sdk-date, Signature=$HMAC" -d $REQUEST_DATA
else
	curl -s -X $REQUEST_METHOD "https://$REQUEST_HOST$REQUEST_PATH?$REQUEST_PARAM" -H "Content-Type: $REQUEST_CONTENT_TYPE" -H "X-Sdk-Date: $REQUEST_TIME" -H "host: $REQUEST_HOST" -H "Authorization: SDK-HMAC-SHA256 Access=$ACCESS_KEY, SignedHeaders=content-type;host;x-sdk-date, Signature=$HMAC" -d $REQUEST_DATA
fi
