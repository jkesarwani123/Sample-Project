script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

print_head Install GoLang
yum install golang -y

print_head Add Application User
useradd ${app_user}

print_head Create Application Directory
rm -rf /app
mkdir /app

print_head Download App Content
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip
cd /app

print_head Unzip App Content
unzip /tmp/dispatch.zip

print_head Install Java Dependencies
go mod init dispatch
go get
go build

print_head Copy Dispatch SystemD file
cp ${script_path}/dispatch.service /etc/systemd/system/dispatch.service

print_head Start Dispatch Service
systemctl daemon-reload
systemctl enable dispatch
systemctl restart dispatch