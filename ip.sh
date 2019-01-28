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
  #i=`find /var/www/mediadb/preview/ -name "*.jpg" | sort -R | tail -1`
  #echo $i
  #cp $i /var/www/pics/background.jpg
fi

export PATH=$PATH:/opt/postgresql/latest/bin
image=`psql -h localhost -U mediadb mediadb < /home/mfranke/marex19.github.io/hiking.sql | sort -R | tail -1 | sed 's/^\ //'`
convert -resize 50% "$image" /var/www/pics/background.jpg

