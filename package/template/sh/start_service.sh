#!/bin/bash

##################################################################################
#	名称：微服务启动脚本 V1.0												      #
#	作用：启动微服务														      #
#	日期：20200309                                                               #
#	描述：start_service.sh <APPLICATION_NAME> <VERSION> <PLATFORM_HOME>          #
#   状态码：                                                                     #
#		10：服务无法关闭                                                          #
#		9：服务无法启动                                                           #
#		0：服务启动成功                                                           #
##################################################################################

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
export PATH
ulimit -n 8192

JAVA_HOME=/home/vagrant/software/jdk1.8.0_231


APP_NAME=$1
VERSION=$2
PLATFORM_HOME=$3

jvmArgs=" -server -Xms512m -Xmx1024m  -Xss512k -XX:PermSize=128M -XX:MaxNewSize=64m -XX:MaxPermSize=128m -Djava.awt.headless=true -Djava.net.preferIPv4Stack=true -Dspring.profiles.active=prod -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/data/BAK/snapshot2.hprof "

CLASSPATH=$JAVA_HOME/lib:$JAVA_HOME/jre/lib
LANG=zh_CN.GB18030
export JAVA_HOME PLATFORM_HOME CLASSPATH LANG

Search_Str=$APP_NAME-$VERSION

LOG=$PLATFORM_HOME/logs/$APP_NAME.log


############################################
#		core logic                         #
############################################


# 服务未启动或服务成功关闭，返回0；服务关闭失败，返回1
function stop(){
	# echo "enter stop()..."
	cd $PLATFORM_HOME/
	PID=`ps auxwww|grep java|grep $Search_Str|awk '{ print $2 }'`
	returnCode=0
	if [ -z "$PID" ]; then
		echo "no pid found. $0 no start"
		returnCode=0
	else
		kill -9 $PID && returnCode=0 || returnCode=1
	fi
	[[ -f $LOG ]] && mv -vf $LOG $LOG.`date +%Y%m%d%H`

	# echo "leave stop()..."
	return $returnCode
}

# 搜索进程Id，搜索到了返回0，表示启动成功；未搜索到返回1，表示启动失败
function check(){
	# echo "enter check()..."

	PID=`ps auxwww|grep java|grep $Search_Str|awk '{ print $2 }'`
	returnCode=0
	if [ -z "$PID" ]; then
        echo -n "no pid found. $0 no start."
		returnCode=1
	else
        echo "pid $PID found. $0 started"
		returnCode=0
	fi

	# echo "live check()..."
	return $returnCode
}

# 启动指令执行失败，返回1；启动指令成功，则返回check的返回值
function start(){
	# echo "enter start()..."

	cd $PLATFORM_HOME/
	nohup $JAVA_HOME/bin/java  -Djava.ext.dirs=$PLATFORM_HOME/lib:$JAVA_HOME/jre/lib/ext   $jvmArgs   -jar $APP_NAME-$VERSION.jar  >$LOG 2>&1 &
	returnCode=0
	if [ $? -ne 0 ];then
		echo "$0 start failed"
		tail -20 $LOG
		return 1
	else
		echo "$0 start success"
	fi
	chmod 644 $LOG
	sleep 2

	# echo "live start()..."
	check
	return $?
}

# 尝试3次关闭服务
stop
stopReturnCode=$?
stopTryCount=0
while ((stopReturnCode != "0" && stopTryCount < 3))
do 
	echo "service cosing tring times $stopTryCount"
	let stopTryCount+=1
	sleep 2
	stop
	stopReturnCode=$?
done

if [ $stopReturnCode -ne 0 ];then
	echo "$0 start failed"
fi

if [ $stopReturnCode -ne 0 ]; then
	echo "service close failed"
	exit 10
fi

# 尝试3次启动服务
start
startReturnCode=$?
startTryCount=0
while ((startReturnCode != 0 && startTryCount < 3))
do 
	echo "service staring tring times $startTryCount"
	let startTryCount+=1
	sleep 2
	start
	startReturnCode=$?
done

if [ $startReturnCode -ne 0 ]; then
	echo "service start failed"
	exit 9
fi


sleep 10
tail -20 $LOG
echo "deploy suffessfully..."
exit 0