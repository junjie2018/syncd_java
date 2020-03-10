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

tar -zxvf go/go1.14.linux-amd64.tar.gz -C software/

baseDir=$(pwd)

echo '
export GO_HOME='${baseDir}'/software/go
export PATH=$PATH:$GO_HOME/bin' | sudo tee -a /etc/profile
source /etc/profile