checkCommand() {
    type $1 > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        return 1
    fi
    return 0
}

checkCommand unzip
if [ $? -ne 0 ]; then
    # sudo apt-get install -y unzip
    sudo yum -y install unzip
fi

checkCommand make
if [ $? -ne 0 ]; then
    # sudo apt-get install -y make
    sudo yum -y install make
fi

checkCommand git
if [ $? -ne 0 ]; then
    # sudo apt-get install -y git
    sudo yum -y install git
fi



rm -rf software/*
rm -rf syncd/syncd

# syncd需要用的
syncdHost=10.82.24.46
syncdPort=3306
syncdUser=root
syncdPassword=rootmysql
syncdDbName=syncd

source go/init.sh
source maven/init.sh
source syncd/init.sh
