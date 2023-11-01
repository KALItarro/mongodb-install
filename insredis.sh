#!/bin/bash
lhip=$(ifconfig | grep '255$' | awk '{print $2}')
echo '正在搭建基础环境...'
yum -y install gcc* &> /dev/null
if [ $? -eq 0 ]
then
echo "<yes>		基础环境搭建"
else
echo "基础环境搭建失败，自动暂停"
exit
fi


rm -rf /usr/src/redis-*
tar xf redis-*.tar.gz  -C /usr/src &> /dev/null
if [ $? -eq 0 ]
then
echo "<yes>		解包成功"
else
echo "解包失败，自动暂停"
exit
fi


cd /usr/src/redis-*


echo '正在编译...'
make &> /dev/null
if [ $? -eq 0 ]
then
echo "<yes>		编译成功"
else
echo "编译失败，自动暂停"
exit
fi

echo '正在安装...'
make install &> /dev/null
if [ $? -eq 0 ]
then
echo "<yes>		安装成功"
else
echo "安装失败，自动暂停"
exit
fi

echo "当前所在目录$(pwd)"

cd utils/
echo "当前所在目录$(pwd)"
echo '--------------------------------------'
echo '如果你没有任何修改那么可以一直回车即可<yes>'
echo '如果你没有任何修改那么可以一直回车即可<yes>'
echo '如果你没有任何修改那么可以一直回车即可<yes>'
echo '--------------------------------------'
./install_server.sh 
sed -i 's/^bind 127.0.0.1/bind 127.0.0.1 '$lhip' /g' /etc/redis/*.conf
/etc/init.d/redis_6379 restart
netstat -anpt | grep redis
if [ $? -eq 0 ]
then
echo "redis开启成功"
else
echo "<no>！！！redis服务开启失败,受你环境的影响，无法按照我的思路稳定运行！！！<no>"
exit
fi
