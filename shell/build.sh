env_workspace=/home/vagrant/src/ranking
env_pack_file=/home/vagrant/deploy

# 在${env_workspace}中执行的代码
module_name="hwb-ranking-admin"
package_base="/home/vagrant/package"
package_path=$package_base/$module_name

cd ${env_workspace}

mvn package -Dmaven.test.skip=true 

# 如果master上存放的构建后项目目录结构的文件夹不存在则创建它
if [ ! -d $package_path ];then
    cp -r $package_base/template/ $package_path
fi


rsync -avz $module_name/target/lib $package_path
rsync -avz $module_name/target/config $package_path
rsync -avx $module_name/target/*.jar $package_path

cd $package_path
tar -zcvf ${env_pack_file} *

