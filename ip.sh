#!/bin/bash
log="/var/log/ip/ip.log"
tmp="/tmp/tmp_ip.html"
ip=`tail -1 $log`
new_ip=`curl -4 -s http://icanhazip.com`

#echo $ip
#echo $new_ip

if [[ $ip != $new_ip ]]; then
  echo $new_ip >> $log
  cd /home/mfranke/marex19.github.io/
  cat index.html | sed "s/[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/$new_ip/g" > index_new.html
  cp index_new.html index.html
  git commit -a -m "IP Updated" > /dev/null 2>&1
  git push -u origin master > /dev/null 2>&1
  # UPDATE RANDOM BACKGROUND IMAGE
  #i=`find /var/www/mediadb/preview/ -name "*.jpg" | sort -R | tail -1`
  #echo $i
  #cp $i /var/www/pics/background.jpg
#fi
  export PATH=$PATH:/opt/postgresql/latest/bin
  image=`psql -h localhost -U mediadb mediadb < /home/mfranke/marex19.github.io/hiking.sql | sort -R | tail -1 | sed 's/^\ //'`
  title=`echo $image | awk 'BEGIN {FS="/"} {print $(NF-1)}'`
  font=`convert -list font | grep "Font" | sed 's/^\ \ Font:\ //' | sort -R | tail -1`
  #echo "$title"
  #echo $font
  cp "$image" /tmp/tmp.jpg
  convert -resize 50% -font $font -fill black -pointsize 20 -annotate +50+100 "$title" /tmp/tmp.jpg /var/www/html/pics/background.jpg
  rm -f /tmp/tmp.jpg
fi

