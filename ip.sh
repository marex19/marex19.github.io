#!/bin/bash
log="/var/log/ip/ip.log"
tmp="/tmp/tmp_ip.html"
ip=`tail -1 $log`
new_ip=`curl -4 -s http://icanhazip.com`

#echo $ip
#echo $new_ip

if [[ $ip != $new_ip ]]; then
  echo $new_ip >> $log
  cd /home/mfranke/enter/
  cat enter.html | sed "s/[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/$new_ip/g" > enter_new.html
  mv enter_new.html enter.html
  git commit -a -m "IP Updated" > /dev/null 2>&1
  git push -u origin master > /dev/null 2>&1
  # UPDATE RANDOM BACKGROUND IMAGE
  i=`find /var/www/gallery_preview_large/ -name "*.jpg" | sort -R | tail -1`
  cp $i /var/www/pics/background.jpg
fi


