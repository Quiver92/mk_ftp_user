#~/bin/bash
get_credentials(){
while [ $# -ne 0 ]
do
        read -p "Please enter your $1: " $1
        shift
done
echo `pwgen -s -1`
pass_first=1
pass_second=2
while [ "$pass_first" != "$pass_second" ]
do
        echo
        read -s -p "Password: " pass_first
        echo
        read -s -p "Password (again): " pass_second
        if  [ "$pass_first" != "$pass_second" ]
        then
        echo -e "\nPlease try again"
        else
        continue
        fi
done
password=$pass_first
}

get_user_credentials(){
get_credentials name surname
name_first_letter=`echo "${name:0:1}" | awk '{print tolower($0)}'`
surname_down_case="${surname,,}"
username=$name_first_letter.$surname_down_case
echo "$username :: $password" >> list.passwd
}

get_firm_credentials(){
get_credentials firm_name
surname_down_case="${firm_name,,}"
username=$surname_down_case
echo "$username :: $password" >> list.passwd
}

