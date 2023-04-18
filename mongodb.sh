echo -e "\e[36m>>>>>>>>> Install MongoDB <<<<<<<<\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo
yum install mongodb-org -y

echo -e "\e[36m>>>>>>>>> Change Listen Port <<<<<<<<\e[0m"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf

echo -e "\e[36m>>>>>>>>> start MongoDB service <<<<<<<<\e[0m"
systemctl enable mongod
systemctl restart mongod

