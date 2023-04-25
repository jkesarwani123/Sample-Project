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
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>$log_file
func_status $?

print_head Setup RabbitMQ Repos
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>$log_file
func_status $?

print_head Install ErLang
yum install erlang -y &>>$log_file
func_status $?

print_head Install RabbitMQ
yum install rabbitmq-server -y &>>$log_file
func_status $?

print_head Start RabbitMQ Service
systemctl enable rabbitmq-server &>>$log_file
systemctl start rabbitmq-server &>>$log_file
func_status $?

print_head create one user for the application
rabbitmqctl add_user ${app_user} ${rabbitmq_app_password} &>>$log_file
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$log_file
func_status $?