script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitmq_app_password=$1

if [ -z "$rabbitmq_app_password" ]; then
  echo Input RabbitMQ Root Password Missing
  exit
  else
    echo ${rabbitmq_app_password}
fi

print_head Setup ErLang Repos
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash

print_head Setup RabbitMQ Repos
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash

print_head Install ErLang
yum install erlang -y

print_head Install RabbitMQ
yum install rabbitmq-server -y

print_head Start RabbitMQ Service
systemctl enable rabbitmq-server
systemctl start rabbitmq-server

print_head create one user for the application
rabbitmqctl add_user ${app_user} ${rabbitmq_app_password}
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"