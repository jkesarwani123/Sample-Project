app_user=roboshop

script_path=$(dirname "$script")
source ${script_path}/common.sh

func_nodejs(){
  echo -e "\e[36m>>>>>>>>> Configuring NodeJS repos <<<<<<<<\e[0m"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash

  echo -e "\e[36m>>>>>>>>> Install NodeJS <<<<<<<<\e[0m"
  yum install nodejs -y

  echo -e "\e[36m>>>>>>>>> Add Application User <<<<<<<<\e[0m"
  useradd ${app_user}

  echo -e "\e[36m>>>>>>>>> Create Application Directory <<<<<<<<\e[0m"
  rm -rf /app
  mkdir /app

  echo -e "\e[36m>>>>>>>>> Download App Content <<<<<<<<\e[0m"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
  cd /app

  echo -e "\e[36m>>>>>>>>> Unzip App Content <<<<<<<<\e[0m"
  unzip /tmp/${component}.zip

  echo -e "\e[36m>>>>>>>>> Install NodeJS Dependencies <<<<<<<<\e[0m"
  sudo npm install

  echo -e "\e[36m>>>>>>>>> Copy Cart SystemD file <<<<<<<<\e[0m"
  # cp catalogue.service /etc/systemd/system/catalogue.service
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

  echo -e "\e[36m>>>>>>>>> Start Cart Service <<<<<<<<\e[0m"
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl restart ${component}

}
