script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

echo -e "\e[36m>>>>>>>>> calling nodejs function <<<<<<<<\e[0m"
component=user
func_nodejs
