#!/bin/bash

#------------------------安裝交互自動工具----------------------------#
yum install tcl expect docker-ce git -y


#------------------------git clone-----------------------------------#



#------------------------取得.env檔案內的變數-------------------------#
MYSQL_ROOT_PASSWORD=`cat .env | grep MYSQL_ROOT_PASSWORD | awk -F '=' '{print $2}'`
MYSQL_USER=`cat .env | grep MYSQL_USER | awk -F '=' '{print $2}'`
MYSQL_PASSWORDD=`cat .env | grep MYSQL_PASSWORD | awk -F '=' '{print $2}'`
mysql_port=`cat .env | grep mysql_port | awk -F '=' '{print $2}'`


#-----------------------啟動docker-compose-------------------------#
docker-compose up -d

echo "watting for db setup...."
/usr/bin/sleep 15

/usr/bin/expect <<EOF
    spawn mysql -uroot -p -h 192.168.0.11 -P ${mysql_port}
    expect {
            "*password:*" { send "${MYSQL_ROOT_PASSWORD}\r";}
             "*#" { send "in mysql";}
    }
    expect eof
EOF
