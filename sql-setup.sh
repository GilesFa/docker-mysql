#!/bin/bash
#-----------------------firewall開port----------------------------#

if [ $? -eq 0 ]
  then
    echo "firewalld is running"
else
    echo "firewalld is not running... let's enable it.."
    systemctl start firewalld
    firewall-cmd --add-port=3366/tcp --permanent
    firewall-cmd --add-port=8080/tcp --permanent
    firewall-cmd --reload
    firewall-cmd --list-all
    setenforce 0
fi

#------------------------安裝交互自動工具----------------------------#
yum install tcl expect docker-ce git mysql ifconfig -y


#------------------------git clone-----------------------------------#



#------------------------取得.env檔案內的變數-------------------------#
MYSQL_ROOT_PASSWORD=`cat .env | grep MYSQL_ROOT_PASSWORD | awk -F '=' '{print $2}'`
MYSQL_USER=`cat .env | grep MYSQL_USER | awk -F '=' '{print $2}'`
MYSQL_PASSWORDD=`cat .env | grep MYSQL_PASSWORD | awk -F '=' '{print $2}'`
mysql_port=`cat .env | grep mysql_port | awk -F '=' '{print $2}'`
LOCAL_IP=`ifconfig | egrep -o "\<([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-1][0-9]|22[0-3])\>.(\<([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\>\.){2}\<([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-4])\>" |grep 192`

#-----------------------啟動docker-compose-------------------------#
docker-compose up -d

echo "watting for db setup ."
/usr/bin/sleep 1
echo "watting for db setup .."
/usr/bin/sleep 1
echo "watting for db setup ..."
/usr/bin/sleep 1
echo "watting for db setup ...."
/usr/bin/sleep 1
echo "watting for db setup ....."
/usr/bin/sleep 25

echo "check web 8080 port ."
echo "check web 8080 port .."
echo "check web 8080 port ..."
echo "check web 8080 port ...."
curl http://$IP:8080

/usr/bin/expect <<EOF
    spawn mysql -uroot -p -h ${LOCAL_IP} -P ${mysql_port}
    expect {
            "*password:*" { send "${MYSQL_ROOT_PASSWORD}\r";}
             "*#" { send "in mysql";}
    }
    expect eof
EOF
