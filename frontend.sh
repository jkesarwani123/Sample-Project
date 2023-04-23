source common.sh

echo -e "\e[36m>>>>>>>>> Install NJINX server <<<<<<<<\e[0m"
yum install nginx -y

echo -e "\e[36m>>>>>>>>> Copy Config file <<<<<<<<\e[0m"
cp roboshop.conf /etc/nginx/default.d/roboshop.conf

echo -e "\e[36m>>>>>>>>> Remove frontend page <<<<<<<<\e[0m"
rm -rf /usr/share/nginx/html/*

echo -e "\e[36m>>>>>>>>> Download and unzip frontend files <<<<<<<<\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

echo -e "\e[36m>>>>>>>>> start NGINX server <<<<<<<<\e[0m"
systemctl enable nginx
systemctl restart nginx