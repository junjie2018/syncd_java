# 部署前
syncd_deploy_path="/home/vagrant/deploy" \
    && rm -rf $syncd_deploy_path \
    && mkdir $syncd_deploy_path

# 部署后
syncd_deploy_path="/home/vagrant/deploy" \
    && module_name="hwb-ranking-admin" \
    && version="1.0-SNAPSHOT" \
    && platform_base="/home/vagrant/deploy_true" \
    && platform_home=$platform_base/$module_name \
    && mkdir -p $platform_home \
    && rsync -avz $syncd_deploy_path/ $platform_home \
    && cd $platform_home \
    && sh/start_service.sh $module_name $version $platform_home


