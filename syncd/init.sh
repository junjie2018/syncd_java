function log(){
    echo -e "\033[42;37m"$1"\033[0m"
}
function error(){
    echo -e "\033[41;37m"$1"\033[0m"
}

function judgeBaseDir(){
    executePath=$(basename "$PWD")
    if [ $executePath != "DeployTools" ]; then
        error "Please run this script in 'DeployTools'. Cur dir: $executePath"
        exit 1
    fi
    log "BaseDir right..."
}

checkCommand() {
    type $1 > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "error: $1 must be installed"
        echo "install exit"
        exit 1
    fi
}

judgeBaseDir

unzip syncd/dreamans-syncd-master.zip -d syncd/

baseDir=$(pwd)
syncd_repo_path=${baseDir}/syncd/syncd
syncd_install_path=${baseDir}/software/syncd-deploy

checkCommand "go"
checkCommand "git"
checkCommand "make"

if [ -d ${syncd_install_path} ];then
    syncd_install_path=${syncd_install_path}-$( date +%Y%m%d%H%M%S )
fi

cd ${syncd_repo_path}
make

rm -fr ${syncd_install_path}
cp -r ${syncd_repo_path}/output ${syncd_install_path}

cat << EOF

Installing Syncd Path:  ${syncd_install_path}
Install complete.

EOF


# copy配置文件到指定位置
cp ${baseDir}/syncd/conf/* ${baseDir}/software/syncd-deploy/etc
sed -i "s#databaseHostPlaceholder#$syncdHost#g" ${baseDir}/software/syncd-deploy/etc/syncd.ini
sed -i "s#databasePortPlaceholder#$syncdPort#g" ${baseDir}/software/syncd-deploy/etc/syncd.ini
sed -i "s#databasePortUserPlaceholder#$syncdUser#g" ${baseDir}/software/syncd-deploy/etc/syncd.ini
sed -i "s#databasePasswordPlaceholder#$syncdPassword#g" ${baseDir}/software/syncd-deploy/etc/syncd.ini
sed -i "s#databaseDbNamePlaceholder#$syncdDbName#g" ${baseDir}/software/syncd-deploy/etc/syncd.ini

echo '
export SYNCD_HOME='${baseDir}'/software/syncd-deploy
export PATH=$PATH:$SYNCD_HOME/bin' | sudo tee -a /etc/profile
source /etc/profile

cd ${baseDir}/software/syncd-deploy && nohup ./bin/syncd >logs_syncd 1>logs_nohup &




