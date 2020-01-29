#!/bin/sh

NEW_IP=`curl -s http://ipv4.icanhazip.com`
CURRENT_IP=`cat ~/tmp/current_ip.txt`
CURRENT_TIME=$(date +"%F %T")
if [ "$NEW_IP" = "$CURRENT_IP" ]
then
        echo "[$CURRENT_TIME] No Change in IP Adddress" >> ~/tmp/crontab_log.txt
else

curl -X PUT "https://api.cloudflare.com/client/v4/zones/{{ZONE_ID}}/dns_records/{{RECORD_ID}}" \
     -H "X-Auth-Email:{{YOUR_EMAIL}}" \
     -H "X-Auth-Key:{{YOUR_TOKEN_OR_GLOBAL_KEY}}" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"{{YOUR_DOMAIN_FOR_DDNS}}","content":"'$NEW_IP'","ttl":1,"proxied":false}' > /dev/null
echo $NEW_IP > ~/tmp/current_ip.txt
echo "[$CURRENT_TIME] IP changed to $NEW_IP" >> ~/tmp/crontab_log.txt
fi
