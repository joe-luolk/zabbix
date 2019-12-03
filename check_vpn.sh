#！/bin/sh

if [ -z "$1" ];then
  tunnel_info=`ip addr|grep "inet"|egrep "ppp|tun"`
  if [ "$tunnel_info" ];then
  	tunnel_infonum=$(echo "$tunnel_info"|wc -l)
  	echo {
        echo '  "data"':[        
  	if [ $tunnel_infonum -eq 1 ];then
      echo '      {"{#DEVNAME}":"'"$devname"'","{#IP}":"'"$ip"'"'}
    else
      tmp=1
      echo "$tunnel_info"|while read line
      do
      	devname=$(echo "$line"|awk '{print $NF}')
      	ip=$(echo "$line"|awk '{print $2}'|awk -F/ '{print $1}')
        if [ $tmp -eq $tunnel_infonum ];then
          echo '      {"{#DEVNAME}":"'"$devname"'","{#IP}":"'"$ip"'"'}
        else
          echo '      {"{#DEVNAME}":"'"$devname"'","{#IP}":"'"$ip"'"'},
        fi
        let tmp+=1 
      done
    fi
    echo '  ]'
    echo }
  fi
elif [ $# -eq 1 ];then 
  netwrork_status=$(fping -a -t 300 $1)
  if [ "$netwrork_status" ];then
  	echo 1
  else
  	echo 0
  fi
elif [ $# -eq 2 ];then
  device_info=$(ip addr|grep "inet"|grep $1)
  if [ "$device_info" ];then
    echo 1
  else
    echo 0
  fi
fi
