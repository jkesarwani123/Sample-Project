echo -e "\e[36m>>>>>>>>> Configuring NodeJS repos <<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[36m>>>>>>>>> Install NodeJS <<<<<<<<\e[0m"
yum install nodejs -y

echo -e "\e[36m>>>>>>>>> Add Application User <<<<<<<<\e[0m"
useradd roboshop

echo -e "\e[36m>>>>>>>>> Create Application Directory <<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>>>>> Download App Content <<<<<<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip
cd /app

echo -e "\e[36m>>>>>>>>> Unzip App Content <<<<<<<<\e[0m"
unzip /tmp/cart.zip

echo -e "\e[36m>>>>>>>>> Install NodeJS Dependencies <<<<<<<<\e[0m"
sudo npm install

echo -e "\e[36m>>>>>>>>> Copy User SystemD file <<<<<<<<\e[0m"
# cp catalogue.service /etc/systemd/system/catalogue.service
cp /home/centos/Sample-Project/cart.service /etc/systemd/system/cart.service

echo -e "\e[36m>>>>>>>>> Start User Service <<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable cart
systemctl restart cart
