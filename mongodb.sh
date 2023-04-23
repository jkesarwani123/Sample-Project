script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

print_head Install MongoDB
cp mongo.repo /etc/yum.repos.d/mongo.repo
yum install mongodb-org -y

print_head Change Listen Port
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf

print_head start MongoDB service
systemctl enable mongod
systemctl restart mongod

