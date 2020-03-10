#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
export PATH
ulimit -n 8192

JAVA_HOME=/home/vagrant/software/jdk1.8.0_231


# 第2、3、4、5个位置参数位置
APP_NAME=$2 
VERSION=$3
PLATFORM_HOME=$4

# jvmArgs=" -server -Xms512m -Xmx1024m  -Xss512k -XX:PermSize=128M -XX:MaxNewSize=64m -XX:MaxPermSize=128m -Djava.awt.headless=true -Djava.net.preferIPv4Stack=true -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/data/BAK/snapshot2.hprof "

# CLASSPATH=$JAVA_HOME/lib:$JAVA_HOME/jre/lib
# LANG=zh_CN.GB18030
# export JAVA_HOME PLATFORM_HOME CLASSPATH LANG

# Search_Str=$APP_NAME-$VERSION

# LOG=$PLATFORM_HOME/logs/$APP_NAME.log

case $1 in
# 	cd $PLATFORM_HOME/
# 	nohup $JAVA_HOME/bin/java  -Djava.ext.dirs=$PLATFORM_HOME/lib:$JAVA_HOME/jre/lib/ext   $jvmArgs   -jar $APP_NAME-$VERSION.jar  >$LOG 2>&1 &
# 	if [ $? -ne 0 ];then
# 		echo "$0 start failed"
# 	else
# 		echo "$0 start success"
# 	fi
# 	chmod 644 $LOG
# 	sleep 2
# 	$0 chk
# stop)
# 	cd $PLATFORM_HOME/
# 	PID=`ps auxwww|grep java|grep $Search_Str|awk '{ print $2 }'`
# 	if [ -z "$PID" ]; then
# 		echo "no pid found. $0 no start?"
# 	else
# 		kill -9 $PID && echo "kill pid $PID success." || echo "kill pid $PID failed."
# 	fi
# 	[[ -f $LOG ]] && mv -vf $LOG $LOG.`date +%Y%m%d%H`
# ;;
# forcestop|fstop)
# 	PID=`ps auxwww|grep java|grep $Search_Str|awk '{ print $2 }'`
# 	if [ -z "$PID" ]; then
# 		echo "no pid found. $0 no start?"
# 	else
# 		# todo 生产环境中需要为这个地方配置sudo么
# 		kill -9 $PID && echo "kill pid $PID success." || echo "kill pid $PID failed."
# 	fi
# ;;
# check|chk)
# 	PID=`ps auxwww|grep java|grep $Search_Str|awk '{ print $2 }'`
# 	if [ -z "$PID" ]; then
#         	echo -n "no pid found. $0 no start.make it start?(y/n) "
# 		read Confirm
# 		if [ "$Confirm" = "y" ];then
# 			$0 start
# 		else
# 			echo "You said no start"
# 		fi
# 	else
#         	echo "pid $PID found. $0 started"
# 	fi
# ;;
start0)
	exit 0
;;
start1)
	exit 1
;;
start2)
	exit 2
;;
start3)
	exit 3
;;
# autochk)
# 	PID=`ps auxwww|grep java|grep $Search_Str|awk '{ print $2 }'`
# 	if [ -z "$PID" ]; then
# 		echo "no pid found. $0 auto start"
# 		$0 start
#         else
#                 echo "find pid $PID."
# 	fi
# ;;
# readlog)
# 	[[ -z "$2" ]] && tLine=20 || tLine=$2
# 	cd $PLATFORM_HOME/
# 	tail -n $tLine $LOG
# ;;
*)
	echo -e "Usage: $0 [start <app_name> <version> <platform_home>|stop <app_name> <version> <platform_home>|restart <app_name> <version> <platform_home>|chk|autochk|readlog <lines>|forcestop]"
	exit 0
esac
