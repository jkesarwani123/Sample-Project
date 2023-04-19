echo -e "\e[36m>>>>>>>>> Install Redis <<<<<<<<\e[0m"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
dnf module enable redis:remi-6.2 -y
yum install redis -y

# Change Listen port from 127.0.0.1 to 0.0.0.0
echo -e "\e[36m>>>>>>>>> Change Listen Port <<<<<<<<\e[0m"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/redis.conf
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/redis/redis.conf

echo -e "\e[36m>>>>>>>>> start Redis service <<<<<<<<\e[0m"
systemctl enable redis
systemctl start redis