curl -sL https://rpm.nodesource.com/setup_lts.x | bash
yum install nodejs -y
useradd roboshop

mkdir /app
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app
unzip /tmp/catalogue.zip
npm install
cp catalogue.service /etc/systemd/system/catalogue.service
systemctl daemon-reload

# Mongo Schema
cp mongodb.sh /etc/yum.repos.d/mongo.repo
yum install mongodb-org-shell -y
mongo --host MONGODB-SERVER-IPADDRESS </app/schema/catalogue.js