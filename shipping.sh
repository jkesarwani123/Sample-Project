script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_password=$1

if [ -z "$mysql_password" ]; then
  echo Input MySQL Root Password Missing
  exit
  else
    echo ${mysql_password}
fi

component=shipping
schema_setup=mysql

func_java


