script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

print_head "calling nodejs function"
component=catalogue
schema_setup=mongo
func_nodejs

