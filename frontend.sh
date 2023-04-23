script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

print_head Install NJINX server
yum install nginx -y

print_head Copy Config file
cp roboshop.conf /etc/nginx/default.d/roboshop.conf

print_head Remove frontend page
rm -rf /usr/share/nginx/html/*

print_head Download and unzip frontend files
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

print_head start NGINX server
systemctl enable nginx
systemctl restart nginx