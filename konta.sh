#!/bin/bash
#Place for usage


############################################
#SFTP functions
#name+surname function (if not a firm case)
#Нужно дописать часть с переменной $username для функции ins_to_sshd_conf()

get_credentials(){
while [ $# -ne 0 ]
do
        read -p "Please enter your $1: " $1
        shift
done
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

#credentials to user. Means name and surname. Output will be like a "w.lytovka"
get_user_credentials(){
get_credentials name surname
name_first_letter=`echo "${name:0:1}" | awk '{print tolower($0)}'`
surname_down_case="${surname,,}"
username=$name_first_letter.$surname_down_case
echo "$username :: $password" >> list.passwd
}


#credentials to Firm case
#Нужно дописать часть с переменной $username для функции ins_to_sshd_conf()
get_firm_credentials(){
get_credentials firm_name
surname_down_case="${firm_name,,}"
username=$surname_down_case
echo "$username :: $password" >> list.passwd
}

#Change password function
change_password(){
get_credentials usename
surname_down_case="${firm_name,,}"
username=$surname_down_case
echo "$username :: $password" >> list.passwd
echo -e "$password\n$password" | passwd $username &>/dev/null
echo 
echo "Password successfully updated"
}
#Add records to sshd_config fiile
ins_to_sshd_conf(){
ssh_conf=/etc/ssh/sshd_config
echo >>$ssh_conf
echo "Match User $username">>$ssh_conf
echo "ChrootDirectory /mnt/sftp/$username/">>$ssh_conf
echo "X11Forwarding no">>$ssh_conf
echo "AllowTcpForwarding no">>$ssh_conf
echo "ForceCommand internal-sftp">>$ssh_conf
}

#Add user to sftp (this function use credentials from get_user_credentials() function)
add_user_to_sftp(){
useradd  -m $username -s /bin/false -d /mnt/sftp/$username
echo -e "$password\n$password" | passwd $username &> /dev/null
mkdir -p /mnt/sftp/$username/pliki
chown $username:$username /mnt/sftp/$username/pliki
chown root:root /mnt/sftp/$username
echo
service ssh restart
echo
echo "User successfully added"

}
##############################################

##############################################
#Apache2 SFTP Part

##############################################

##############################################
#Function to make all menu and submenu
menu(){
tput clear
tput setaf 3
echo "Grupa Prawna Koksztys"
tput sgr0


#Title
(tput cup 5 5 ; tput bold ; echo "===============================" ; 
tput cup 6 15 ; tput bold ; echo "	Menu			" ; 
tput cup 7 5 ; tput bold ; echo "===============================")
#Choices
(tput cup 9 5 ; tput setaf 4 ; echo "Enter 1 to add $1" ;
tput cup 10 5 ; tput setaf 4 ; echo "Enter 2 to add $2" ; 
tput cup 11 5 ; tput setaf 4 ; echo "Enter 3 to see $3" ;
tput cup 12 5 ; tput setaf 5 ; echo "Enter q to exit" ;  
tput cup 14 5 ; echo -e "Enter your selection:")
#Answer
tput cup 14 27
read answer
tput clear
tput sgr0
}
##################################################

##################################################
#Main menu
options=("SFTP" "Apache_SFTP" "Info")
menu ${options[0]} ${options[1]} ${options[2]}

case "$answer" in

#Case SFTP
	1)
		options=("Add_User" "Add_Firm" "Password_Reset")
		menu ${options[0]} ${options[1]} ${options[2]}

			case "$answer" in
				1)
					get_user_credentials
					ins_to_sshd_conf
					add_user_to_sftp
				;;
				2)
					get_firm_credentials
                                        ins_to_sshd_conf
                                        add_user_to_sftp
				;;
				3)
					change_password
				;;
				q)
					exit
				;;

			esac 
	;;

#Case Apache SFTP
	2)
		options=("Add_User" "Add_Firm" "Password_Reset")
		menu ${options[0]} ${options[1]} ${options[2]}
			case "$answer" in
				1)
					menu 
				;;
				2)
					
				;;
				3)
					
				;;
				q)
					exit
				;;
			esac
	;;

#Case Info
	3)	
		tput clear
		tput setaf 3
		cat README.md
		tput sgr0
	;;

#Case Exit
	q)
		exit		
	;;
esac
#####################################################
