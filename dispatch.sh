echo -e "\e[36m>>>>>>>>> Install GoLang <<<<<<<<\e[0m"
yum install golang -y

echo -e "\e[36m>>>>>>>>> Add Application User <<<<<<<<\e[0m"
useradd roboshop

echo -e "\e[36m>>>>>>>>> Create Application Directory <<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>>>>> Download App Content <<<<<<<<\e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip
cd /app

echo -e "\e[36m>>>>>>>>> Unzip App Content <<<<<<<<\e[0m"
unzip /tmp/dispatch.zip

echo -e "\e[36m>>>>>>>>> Install Java Dependencies <<<<<<<<\e[0m"
go mod init dispatch
go get
go build

echo -e "\e[36m>>>>>>>>> Copy Dispatch SystemD file <<<<<<<<\e[0m"
# cp shipping.service /etc/systemd/system/shipping.service
cp /home/centos/Sample-Project/dispatch.service /etc/systemd/system/dispatch.service

echo -e "\e[36m>>>>>>>>> Start Shipping Service <<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable dispatch
systemctl restart dispatch