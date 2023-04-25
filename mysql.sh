script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
sql_password=$1

if [ -z "$sql_password" ]; then
  echo Input MySQL Root Password Missing
  exit
  else
    echo ${sql_password}
fi

print_head "Un-Install SQL"
dnf module disable mysql -y &>>$log_file
func_status $?

print_head "Copy repo file"
cp ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo &>>$log_file
func_status $?

print_head "Install SQL"
yum install mysql-community-server -y &>>$log_file
func_status $?

print_head "Start SQL service"
systemctl enable mysqld &>>$log_file
systemctl start mysqld &>>$log_file
func_status $?

print_head "set password for SQL"
mysql_secure_installation --set-root-pass ${sql_password} &>>$log_file
func_status $?
# mysql -uroot -p${sql_password}