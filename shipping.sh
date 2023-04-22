echo -e "\e[36m>>>>>>>>> Install Maven for java <<<<<<<<\e[0m"
yum install maven -y

echo -e "\e[36m>>>>>>>>> Add Application User <<<<<<<<\e[0m"
useradd roboshop

echo -e "\e[36m>>>>>>>>> Create Application Directory <<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>>>>> Download App Content <<<<<<<<\e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip
cd /app

echo -e "\e[36m>>>>>>>>> Unzip App Content <<<<<<<<\e[0m"
unzip /tmp/shipping.zip

echo -e "\e[36m>>>>>>>>> Install Java Dependencies <<<<<<<<\e[0m"
mvn clean package
mv target/shipping-1.0.jar shipping.jar

echo -e "\e[36m>>>>>>>>> Copy Shipping SystemD file <<<<<<<<\e[0m"
# cp shipping.service /etc/systemd/system/shipping.service
cp /home/centos/Sample-Project/shipping.service /etc/systemd/system/shipping.service

echo -e "\e[36m>>>>>>>>> Load SQL Schema <<<<<<<<\e[0m"
yum install mysql -y
mysql -h mysql.jkdevops.online -uroot -pRoboShop@1 < /app/schema/shipping.sql

echo -e "\e[36m>>>>>>>>> Start Shipping Service <<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable shipping
systemctl restart shipping



