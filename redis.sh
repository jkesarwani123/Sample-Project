script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

print_head Install Redis
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$log_file
dnf module enable redis:remi-6.2 -y &>>$log_file
yum install redis -y &>>$log_file

# Change Listen port from 127.0.0.1 to 0.0.0.0
print_head Change Listen Port
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/redis.conf /etc/redis/redis.conf

print_head start Redis service
systemctl enable redis &>>$log_file
systemctl restart redis &>>$log_file