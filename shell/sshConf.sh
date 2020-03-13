# 脚本执行前删除临时文件
rm ./tmp/sshServices.tmp
rm ./tmp/sshServices.incr

#################################################
function log(){
    echo -e "\033[42;37m"$1"\033[0m"
}
function error(){

}
#################################################





# 拿到当前配置文件中的所有Ip
log "generate tmp/sshServices.tmp start..."
cat ./conf/services.conf | grep "^[a-zA-Z]" | while read line
do
    serviceAndIp=(${line//:/ })

    serviceIp=${serviceAndIp[1]}

    echo -e ${serviceIp} | tee -a ./tmp/sshServices.tmp
done





# 与已经配置的进行对比
# todo 这个地方加一个计数的地
log "generate tmp/sshServices.persist start..."
if [ -e ./tmp/sshServices.persist ] 
then
    grep -F -f ./tmp/sshServices.tmp ./tmp/sshServices.persist | sort | uniq | tee -a ./tmp/sshServices.incr
else
    cp ./tmp/sshServices.tmp ./tmp/sshServices.incr
fi





# 判断ssh公钥秘钥是否存在
if [ ! -e ~/.ssh/id_rsa.pub ]
then
    log "ssh秘钥不存在，创建ssh秘钥"
    ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
else
    log "ssh秘钥已存在，将公钥拷贝到指定服务器"
fi





# 处理incre中的ip，建立ssh免密登录
log "sending public-key to services..."
cat ./tmp/sshServices.incr | while read line
do
    echo "发送公钥到："+${line}
    echo ${line} | tee -a ~/.ssh/knowns_hosts
    ssh-copy-id -i ~/.ssh/id_rsa.pub vagrant@${line}
done





