#!/bin/sh

if [ -z "$1" ];then
	tcp_connect="`netstat -n|awk '/^tcp/{++status[$NF]} END {for(stats in status) print stats,status[stats]}'`"
	tcp_num=$(echo "$tcp_connect"|wc -l)
	if [ $tcp_num -gt 1 ];then 
      echo {
      echo '  "data"':[ 
      echo '      {"{#TCPSTATE}":"'"ESTABLISHED"'"'},
      echo '      {"{#TCPSTATE}":"'"TIME_WAIT"'"'},
      echo '      {"{#TCPSTATE}":"'"FIN_WAIT2"'"'},
      echo '      {"{#TCPSTATE}":"'"SYN_SENT"'"'},
      echo '      {"{#TCPSTATE}":"'"FIN_WAIT1"'"'},
      echo '      {"{#TCPSTATE}":"'"SYN_RECV"'"'},
      echo '      {"{#TCPSTATE}":"'"CLOSE_WAIT"'"'},
      echo '      {"{#TCPSTATE}":"'"CLOSING"'"'},
      echo '      {"{#TCPSTATE}":"'"LAST_ACK"'"'}
      echo '  ]'
      echo }
    fi 
else
    content=$(netstat -n|awk '/^tcp/{++status[$NF]} END {for(stats in status) print stats,status[stats]}'|grep "$1")
    if [ "$content" ];then
      echo "$content"|awk '{print $2}'
    else
      echo 0
    fi  
fi