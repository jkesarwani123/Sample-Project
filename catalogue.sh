script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

print_head calling nodejs function
component=catalogue
func_nodejs

print_head Copy MongoDB repo
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

print_head Install MongoDB Client
yum install mongodb-org-shell -y

print_head Load Schema
mongo --host mongodb.jkdevops.online </app/schema/catalogue.js