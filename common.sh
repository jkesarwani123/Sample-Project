app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")
log_file=/tmp/roboshop.log

print_head(){
echo -e "\e[36m>>>>>>>>> $* <<<<<<<<\e[0m"
}

func_status(){
  if [ $1 -eq 0 ]; then
      echo -e "\e[32mSUCCESS\e[0m"
      else
      echo -e "\e[31mFAILURE\e[0m]"
      echo -e "\e[31mRefer to $log_file file for details\e[0m"
      exit 1
    fi

}

schema_setup(){
  if [ "$schema_setup" == "mongo" ]; then
  print_head Copy MongoDB repo
  cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file
  func_status $?

  print_head Install MongoDB Client
  yum install mongodb-org-shell -y &>>$log_file
  func_status $?

  print_head Load Schema
  mongo --host mongodb.jkdevops.online </app/schema/${component}.js &>>$log_file
  func_status $?
  fi

  if [ "$schema_setup" == "mysql" ]; then
    print_head Load SQL Schema
    yum install mysql -y &>>$log_file
    func_status $?

    mysql -h mysql.jkdevops.online -uroot -p${mysql_password} < /app/schema/${component}.sql &>>$log_file
    func_status $?
    fi
}

func_prereq(){
  print_head Add Application User
  useradd ${app_user} &>>$log_file
  # func_status $?

  print_head Create Application Directory
  rm -rf /app &>>$log_file
  mkdir /app &>>$log_file
  func_status $?

  print_head Download App Content
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>$log_file
  func_status $?


  print_head Unzip App Content
  cd /app
  unzip /tmp/${component}.zip &>>$log_file
  func_status $?
}

func_systemd_setup(){

  print_head "Setup ${component} SystemD Service"
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service &>>$log_file
  func_status $?

  print_head "Start ${component} Service"
  systemctl daemon-reload &>>$log_file
  systemctl enable ${component} &>>$log_file
  systemctl restart ${component} &>>$log_file
  func_status $?
}

func_nodejs(){
  print_head Configuring NodeJS repos
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$log_file
  func_status $?

  print_head Install NodeJS
  yum install nodejs -y &>>$log_file
  func_status $?

  print_head Install application content
  func_prereq

  print_head Install NodeJS Dependencies
  sudo npm install &>>$log_file
  func_status $?

  schema_setup
  func_systemd_setup
}

func_java(){
  print_head Install Maven for java
  yum install maven -y &>>$log_file
  func_status $?

  print_head Install application content
  func_prereq

  print_head Install Java Dependencies
  mvn clean package &>>$log_file
  mv target/${component}-1.0.jar ${component}.jar &>>$log_file
  func_status $?

  schema_setup
  func_systemd_setup
}
