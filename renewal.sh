#!/bin/bash

logdir="/opt/scripts/logs"
mkdir $logdir
dt=`date +%d%m%Y`

if [[ -d /etc/apache2 ]]
then
   for domains in `ls /etc/apache2/sites-enabled/`
   do
     cat /etc/apache2/sites-enabled/$domains | grep "ServerName" | awk '{print $2}' >> domains.tmp
   done
   
   cat domains.tmp | sort -u > domain.tmp
   rm domains.tmp
   
   for domain in `cat domain.tmp`
   do
     certbot certonly --apache -d $domain --force-renewal
   done
   
elif [[ -d /etc/nginx ]]
then
   for domains in `ls /etc/nginx/sites-enabled/`
   do
     cat /etc/nginx/sites-enabled/$domains | grep "ServerName" | awk '{print $2}' >> domains.tmp
   done
   
   cat domains.tmp | sort -u > domain.tmp
   rm domains.tmp
   
   for domain in `cat domain.tmp`
   do
     certbot certonly --nginx -d $domain --force-renewal
   done
fi

rm domain.tmp
cp -parv /var/log/letsencrypt/letsencrypt.log $logdir/letsencrypt_$dt.log
