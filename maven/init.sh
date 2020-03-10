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

judgeBaseDir

tar -zxvf maven/apache-maven-3.6.0-bin.tar.gz -C software/

baseDir=$(pwd)
localRepositoryPath=$baseDir/maven/.m2/repository

cp maven/conf/* software/apache-maven-3.6.0/conf
sed -i "s#localRepositoryPlaceholder#$localRepositoryPath#g" software/apache-maven-3.6.0/conf/settings.xml

echo '
export MAVEN_HOME='$baseDir'/software/apache-maven-3.6.0
export PATH=$PATH:$MAVEN_HOME/bin' | sudo tee -a /etc/profile
source /etc/profile


# baseDir=$(pwd) \
#     && localRepositoryPath=$baseDir/maven/.m2/repository \
#     && sed -i "s#localRepositoryPlaceholder#$localRepositoryPath#g" software/apache-maven-3.6.0/conf/settings.xml