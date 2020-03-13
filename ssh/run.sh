paramCount=$#
if((paramCount==0));then
    echo 'No Args'
    exit 1;
fi


paramStr=$*

cat services.conf | while read line
do
    serviceIpAndUser=(${line//:/ })
    serviceIp=${serviceIpAndUser[0]}
    serviceUser=${serviceIpAndUser[1]}

    ssh $serviceUser@$serviceIp $paramStr
done
