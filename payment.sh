source common.sh

echo -e "\e[36m>>>>>>>>> Install Python <<<<<<<<\e[0m"
yum install python36 gcc python3-devel -y

echo -e "\e[36m>>>>>>>>> Add Application User <<<<<<<<\e[0m"
useradd useradd ${app_user}

echo -e "\e[36m>>>>>>>>> Create Application Directory <<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>>>>> Download App Content <<<<<<<<\e[0m"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip
cd /app
unzip /tmp/payment.zip

echo -e "\e[36m>>>>>>>>> Install Dependencies <<<<<<<<\e[0m"
pip3.6 install -r requirements.txt

echo -e "\e[36m>>>>>>>>> Copy payment SystemD file <<<<<<<<\e[0m"
# cp catalogue.service /etc/systemd/system/catalogue.service
cp /home/centos/Sample-Project/shipping.service /etc/systemd/system/payment.service

echo -e "\e[36m>>>>>>>>> Start payment Service <<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable payment
systemctl restart payment