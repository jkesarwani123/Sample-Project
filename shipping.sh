script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_password=$1

if [ -z "$mysql_password" ]; then
  echo Input MySQL Root Password Missing
  exit
  else
    echo ${mysql_password}
fi

print_head Install Maven for java
yum install maven -y

print_head Add Application User
useradd ${app_user}

print_head Create Application Directory
rm -rf /app
mkdir /app

print_head Download App Content
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip
cd /app

print_head Unzip App Content
unzip /tmp/shipping.zip

print_head Install Java Dependencies
mvn clean package
mv target/shipping-1.0.jar shipping.jar

print_head Copy Shipping SystemD file
# cp shipping.service /etc/systemd/system/shipping.service
cp ${script_path}/shipping.service /etc/systemd/system/shipping.service

print_head Load SQL Schema
yum install mysql -y
mysql -h mysql.jkdevops.online -uroot -p${mysql_password} < /app/schema/shipping.sql

print_head Start Shipping Service
systemctl daemon-reload
systemctl enable shipping
systemctl restart shipping



