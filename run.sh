#!/bin/bash
#Place for usage
source menu.sh
source main_functions.sh


############################################
#SFTP functions
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
chown -R $username:$username /mnt/sftp/$username/pliki
chown root:root /mnt/sftp/$username
echo
service ssh restart
echo
echo "User successfully added"

}
##############################################

##############################################
#Apache2 SFTP Part


add_user_to_asftp(){
get_user_credentials
htpasswd -mnb $username $password >> /home/htaccess/.htpasswd
service apache2 restart
}
add_firm_to_asftp(){
get_firm_credentials
htpasswd -mnb $username $password >> /home/htaccess/.htpasswd
service apache2 restart
}

add_sftp_user_to_asftp(){
get_user_credentials
useradd -G koksztysdok -m $username -s /bin/false -d /mnt/sftp/koksztysdok
echo -e "$password\n$password" | passwd $username &> /dev/null
echo
service ssh restart
echo
echo "User successfully added"
}

add_sftp_firm_to_asftp(){
get_firm_credentials
useradd -G koksztysdok -m $username -s /bin/false -d /mnt/sftp/koksztysdok
echo -e "$password\n$password" | passwd $username &> /dev/null
echo
service ssh restart
echo
echo "User successfully added"
}
##################################################

##################################################
#Cases:
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
		options=("Add_User/Reset_Password" "Add_Firm/Reset_Password" "Quick_Info")
		menu ${options[0]} ${options[1]} ${options[2]}
			case "$answer" in
				1)
					options=("Add_KokDoc's_User(Client)" "Add_SFTP_User_To_KokDoc_Group" "Password_Reset_To_KokDoc_User")
                			menu ${options[0]} ${options[1]} ${options[2]} 
						case "$answer" in
							1)
								add_user_to_asftp 
							;;
							2)
								add_sftp_user_to_asftp
							;;
							3)
								
							;;
						esac
				;;
				2)
					
					options=("Add_KoKDoc's_Firm(Client)" "Add_SFTP_Firm_To_KokDoc_Group" "Password_Reset_To_KokDoc_Firm")
                                        menu ${options[0]} ${options[1]} ${options[2]}
						case "$answer" in 
							1)
								add_firm_to_asftp
							;;
							2)
								add_sftp_firm_to_asftp
							;;
							3)
								
							;;
						esac
				;;
				3)
					echo "Info"
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
