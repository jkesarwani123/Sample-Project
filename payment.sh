script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitmq_app_password=$1

print_head Install Python
yum install python36 gcc python3-devel -y

print_head Add Application User
useradd useradd ${app_user}

print_head Create Application Directory
rm -rf /app
mkdir /app

print_head Download App Content
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip
cd /app
unzip /tmp/payment.zip

print_head Install Dependencies
pip3.6 install -r requirements.txt

print_head Copy payment SystemD file
sed -i -e "s|rabbitmq_app_password|${rabbitmq_app_password}" ${script_path}/payment.service
cp ${script_path}/payment.service /etc/systemd/system/payment.service

print_head Start payment Service
systemctl daemon-reload
systemctl enable payment
systemctl restart payment