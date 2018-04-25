#!/bin/bash
##############################################
#Function to make all menu and submenu
menu(){
tput clear
tput setaf 3
echo "Grupa Prawna Koksztys"
tput sgr0


#Title
(tput cup 5 5 ; tput bold ; echo "===============================" ;
tput cup 6 15 ; tput bold ; echo "      Menu                    " ;
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

