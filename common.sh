app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")

print_head(){
echo -e "\e[36m>>>>>>>>> $* <<<<<<<<\e[0m"
}

schema_setup(){
  print_head Copy MongoDB repo
  cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

  print_head Install MongoDB Client
  yum install mongodb-org-shell -y

  print_head Load Schema
  mongo --host mongodb.jkdevops.online </app/schema/${component}.js
}

func_nodejs(){
  print_head Configuring NodeJS repos
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash

  print_head Install NodeJS
  yum install nodejs -y

  print_head Add Application User
  useradd ${app_user}

  print_head Create Application Directory
  rm -rf /app
  mkdir /app

  print_head Download App Content
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
  cd /app

  print_head Unzip App Content
  unzip /tmp/${component}.zip

  print_head Install NodeJS Dependencies
  sudo npm install

  print_head Copy Cart SystemD file
  # cp catalogue.service /etc/systemd/system/catalogue.service
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

  print_head Start Cart Service
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl restart ${component}

  #schema_setup
}
