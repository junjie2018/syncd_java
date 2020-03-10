# sudo apt-get install -y unzip
# sudo apt-get install -y make
# sudo apt-get install -y git

rm -rf software/*
rm -rf syncd/syncd

# syncd需要用的
syncdHost=192.168.75.99
syncdPort=3307
syncdUser=hwb_ranking
syncdPassword=hwb_ranking
syncdDbName=hwb_ranking

source go/init.sh
source maven/init.sh
source syncd/init.sh
