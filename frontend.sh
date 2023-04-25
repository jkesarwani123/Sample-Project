script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

print_head Install NJINX server
yum install nginx -y &>>$log_file
func_status $?

print_head Copy Config file
cp roboshop.conf /etc/nginx/default.d/roboshop.conf &>>$log_file
func_status $?

print_head Remove frontend page
rm -rf /usr/share/nginx/html/* &>>$log_file
func_status $?

print_head Download frontend files
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>$log_file
func_status $?

print_head unzip frontend files
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>$log_file
func_status $?

print_head start NGINX server
systemctl enable nginx &>>$log_file
systemctl restart nginx &>>$log_file
func_status $?