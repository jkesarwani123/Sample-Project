script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
sql_password=$1

echo -e "\e[36m>>>>>>>>> Un-Install SQL <<<<<<<<\e[0m"
dnf module disable mysql -y

echo -e "\e[36m>>>>>>>>> Copy repo file <<<<<<<<\e[0m"
cp ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo

echo -e "\e[36m>>>>>>>>> Install SQL <<<<<<<<\e[0m"
yum install mysql-community-server -y

echo -e "\e[36m>>>>>>>>> Start SQL service <<<<<<<<\e[0m"
systemctl enable mysqld
systemctl start mysqld

echo -e "\e[36m>>>>>>>>> set password for SQL <<<<<<<<\e[0m"
mysql_secure_installation --set-root-pass ${sql_password}
mysql -uroot -p${sql_password}