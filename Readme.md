### DeployTools
#### 介绍
1. 用于快速使用syncd搭建部署平台

#### 使用细节
1. syncd的具体使用方式请参考syncd官网
2. 需要准备的安装包如下，各自放在对应的目录中：
	- go1.14.linux-amd64.tar.gz
	- apache-maven-3.6.0-bin.tar.gz
3. 可以拷贝本地的仓库到maven目录下，可以节约第一次构建的时间
4. 修改syncd的数据库连接在当前目录的init.sh脚本中
5. 不是完全可用，使用前请建虚拟机多测试