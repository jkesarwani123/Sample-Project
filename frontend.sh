script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

print_head Install NJINX server
yum install nginx -y &>>$log_file
print_head Copy Config file
cp roboshop.conf /etc/nginx/default.d/roboshop.conf &>>$log_file

print_head Remove frontend page
rm -rf /usr/share/nginx/html/* &>>$log_file

print_head Download and unzip frontend files
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>$log_file
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>$log_file

print_head start NGINX server
systemctl enable nginx &>>$log_file
systemctl restart nginx &>>$log_file