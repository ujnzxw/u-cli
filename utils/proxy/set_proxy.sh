#!/bin/bash

. $UPATH/utils/func.sh

#--------GLOBAL VARIABLES----------------
APT_CFG_FILE=$UPATH/utils/proxy/apt_config.conf
BASH_SET_CFG_FILE=$UPATH/utils/proxy/bash_set.conf

http_host=''       # 1
http_port=''       # 2
use_auth=''        # 3
use_same=''        # 4
username=''        # 5
password=''        # 6
https_host=''      # 7
https_port=''      # 8
ftp_host=''        # 9
ftp_port=''        # 10
socks_host=''      # 11
socks_port=''      # 12


#--------FUNCTIONS------------------------

# function to configure environment variables
_proxy_config_env()
{
    # _proxy_config_env $http_host $http_port $use_auth $use_same $username $password $https_host $https_port $ftp_host $ftp_port $socks_host $socks_port
    if [[ $use_same == 'y' ]]; then
        if [[ $use_auth == 'y' ]]; then
            sed -i "s/<PROXY>/$username\:$password@$http_host\:$http_port/g" $BASH_SET_CFG_FILE
        else
            sed -i "s/<PROXY>/$http_host:$http_port/g" $BASH_SET_CFG_FILE
        fi
    elif [[ $use_same == 'n' ]]; then
        if [[ $use_auth == 'y' ]]; then
            auth=$username:$password@
        else
            auth=''
        fi
        sed -i '/proxy\|proxy\|PROXY/d' $BASH_SET_CFG_FILE
        echo "http_proxy=$auth$http_host:$http_port"     > $BASH_SET_CFG_FILE
        echo "HTTP_PROXY=$auth$http_host:$http_port"    >> $BASH_SET_CFG_FILE
        echo "https_proxy=$auth$https_host:$https_port" >> $BASH_SET_CFG_FILE
        echo "HTTPS_PROXY=$auth$https_host:$https_port" >> $BASH_SET_CFG_FILE
        echo "ftp_proxy=$auth$ftp_host:$ftp_port"       >> $BASH_SET_CFG_FILE
        echo "FTP_PROXY=$auth$ftp_host:$ftp_port"       >> $BASH_SET_CFG_FILE
        echo "socks_proxy=$auth$socks_host:$socks_port" >> $BASH_SET_CFG_FILE
        echo "SOCKS_PROXY=$auth$socks_host:$socks_port" >> $BASH_SET_CFG_FILE
        read -e -p "Enter proxy settings for rsync in format host:port " -i $http_host:$http_port rsync
        echo "rsync_proxy=$auth$rsync"                  >> $BASH_SET_CFG_FILE
        echo "RSYNC_PROXY=$auth$rsync"                  >> $BASH_SET_CFG_FILE
    fi

    if [[ $use_auth == "y" ]]; then # require authentication
        sed -i "s/<PROXY>/$username:$password@$http_host:$http_port/g" $BASH_SET_CFG_FILE
    else
        sed -i "s/<PROXY>/$http_host:$http_port/g" $BASH_SET_CFG_FILE
    fi

    echo "Modify /etc/environment?"
    if confirm; then
        if [[ -e "/etc/environment" ]]; then
            _sudo_cmd cat $BASH_SET_CFG_FILE >> "/etc/environment"
        else
            _sudo_cmd cat $BASH_SET_CFG_FILE > "/etc/environment"
        fi
    fi
}

_proxy_config_apt()
{
    if [[ ! -e "/etc/apt" ]]; then
        echo "/etc/apt/ does not exist. Make sure apt is configured properly on this system."
        return 1
    fi

    if [[ $use_auth == "n" ]]; then
        if [[ $use_same == "y" ]]; then
            echo Acquire\:\:Http\:\:Proxy\ \"http\:\/\/$http_host\:$http_port\/\"\;      > $APT_CFG_FILE
            echo Acquire\:\:Https\:\:Proxy\ \"https\:\/\/$http_host\:$http_port\/\"\;   >> $APT_CFG_FILE
            echo Acquire\:\:Ftp\:\:Proxy\ \"ftp\:\/\/$http_host\:$http_port\/\"\;       >> $APT_CFG_FILE
            echo Acquire\:\:Socks\:\:Proxy\ \"socks\:\/\/$http_host\:$http_port\/\"\;   >> $APT_CFG_FILE
        elif [[ $use_same == "n" ]]; then
            echo Acquire\:\:Http\:\:Proxy\ \"http\:\/\/$http_host\:$http_port\/\"\;      > $APT_CFG_FILE
            echo Acquire\:\:Https\:\:Proxy\ \"https\:\/\/$https_host\:$https_port\/\"\; >> $APT_CFG_FILE
            echo Acquire\:\:Ftp\:\:Proxy\ \"ftp\:\/\/$ftp_host\:$ftp_port\/\"\;         >> $APT_CFG_FILE
            echo Acquire\:\:Socks\:\:Proxy\ \"socks\:\/\/$socks_host\:$socks_port\/\"\; >> $APT_CFG_FILE
        else
            echo "_proxy_config_apt::use_same: Error!"
            exit 1
        fi

    elif [[ $use_auth == "y" ]]; then
        if [[ $use_same == "y" ]]; then
            sed -i "s/<USERID>/$username/g"   $APT_CFG_FILE
            sed -i "s/<PASSWORD>/$password/g" $APT_CFG_FILE
            sed -i "s/<HOST>/$http_host/g"    $APT_CFG_FILE
            sed -i "s/<PORT>/$http_port/g"    $APT_CFG_FILE
        else
            echo Acquire\:\:Http\:\:Proxy\ \"http\:\/\/$username\:$password\@$http_host\:$http_port\/\"\;        > $APT_CFG_FILE
            echo Acquire\:\:Https\:\:Proxy\ \"https\:\/\/$username\:$password\@$https_host\:$https_port\/\"\;   >> $APT_CFG_FILE
            echo Acquire\:\:Ftp\:\:Proxy\ \"ftp\:\/\/$username\:$password\@$ftp_host\:$ftp_port\/\"\;           >> $APT_CFG_FILE
            echo Acquire\:\:Socks\:\:Proxy\ \"socks\:\/\/$username\:$password\@$socks_host\:$socks_port\/\"\;   >> $APT_CFG_FILE
        fi
    else
        echo "_proxy_config_apt::use_auth: Error encountered!"
        exit 1
    fi

        _sudo_cmd "cat $APT_CFG_FILE >> /etc/apt/apt.conf"
}

_proxy_config_gsettings() {
    gsettings set org.gnome.system.proxy mode 'manual'
    if [[ $use_same == "y" ]]; then
        gsettings set org.gnome.system.proxy use-same-proxy true
        gsettings set org.gnome.system.proxy.http enabled true
        gsettings set org.gnome.system.proxy.http host "'$http_host'";
        gsettings set org.gnome.system.proxy.http port "$http_port";
        gsettings set org.gnome.system.proxy.https host "'$http_host'"
        gsettings set org.gnome.system.proxy.https port "$http_port";
        gsettings set org.gnome.system.proxy.socks host "'$http_host'"
        gsettings set org.gnome.system.proxy.socks port "$http_port";
        gsettings set org.gnome.system.proxy.ftp host "'$http_host'"
        gsettings set org.gnome.system.proxy.ftp port "$http_port";
    else
        gsettings set org.gnome.system.proxy use-same-proxy false
        gsettings set org.gnome.system.proxy.http enabled true
        gsettings set org.gnome.system.proxy.http host "'$http_host'"
        gsettings set org.gnome.system.proxy.http port "$http_port"
        gsettings set org.gnome.system.proxy.https host "'$https_host'"
        gsettings set org.gnome.system.proxy.https port "$https_port"
        gsettings set org.gnome.system.proxy.socks host "'$socks_host'"
        gsettings set org.gnome.system.proxy.socks port "$socks_port"
        gsettings set org.gnome.system.proxy.ftp host "'$ftp_host'"
        gsettings set org.gnome.system.proxy.ftp port "$ftp_port"
    fi
    if [[ $use_auth == "y" ]]; then
        gsettings set org.gnome.system.proxy.http use-authentication true
        gsettings set org.gnome.system.proxy.http authentication-user "'$username'"
        gsettings set org.gnome.system.proxy.http authentication-password "'$password'"
    else
        gsettings set org.gnome.system.proxy.http use-authentication false
        gsettings set org.gnome.system.proxy.http authentication-user "''"
        gsettings set org.gnome.system.proxy.http authentication-password "''"
    fi
}

_proxy_unset_env() {
    if [[ -e "/etc/environment" ]]; then
        echo "Modify /etc/environment. "
        if confirm; then
            _sudo_cmd sed -i '/proxy\|PROXY\|Proxy/d' /etc/environment
            _sudo_cmd sed -i '/end\ of\ proxy\ settings/d' /etc/environment
        else
            echo "Do nothing for unset env"
        fi
    fi

}

_proxy_unset_gsettings() {
    gsettings set org.gnome.system.proxy mode 'none'
    gsettings set org.gnome.system.proxy.http use-authentication false
    gsettings set org.gnome.system.proxy.http authentication-user "''"
    gsettings set org.gnome.system.proxy.http authentication-password "''"
}

_proxy_unset_apt() {
    if [[ -e "/etc/apt/apt.conf" ]]; then
        echo "Modify /etc/apt/apt.conf. "
        if confirm; then
            _sudo_cmd sed -i '/proxy\|PROXY\|Proxy/d' /etc/apt/apt.conf
            _sudo_cmd sed -i '/end\ of\ proxy\ settings/d' /etc/apt/apt.conf
        else
            echo "Do nothing for unset env"
        fi
    fi

}

_proxy_set_params() {
    read -p "Enter Host IP          : " http_host
    read -p "Enter Host Port        : " http_port
    echo "Enable authentication? "
    if confirm; then
        use_auth='y'
        read -p "Enter Proxy Username   : " username
        echo -n "Enter password         : "
        read -s password
        echo
    else
        use_auth='n'
    fi

    echo "Use the different values for all http, https, ftp, socks"
    if confirm; then
        use_same="y"
        echo
        echo "FTP parameters : "
        read -p "Enter Host IP          : " ftp_host
        read -p "Enter Host Port        : " ftp_port
        echo "HTTPS parameters : "
        read -p "Enter Host IP          : " https_host
        read -p "Enter Host Port        : " https_port
        echo "SOCKS parameters : "
        read -p "Enter Host IP          : " socks_host
        read -p "Enter Host Port        : " socks_port
    else
        use_same="n"
    fi

    case $1 in
    ALL)
        _proxy_config_apt
        _proxy_config_gsettings
        _proxy_config_env
        ;;

    env)
        _proxy_config_env
        ;;

    gsettings)
        _proxy_config_gsettings
        ;;
    apt)
        _proxy_config_apt
        ;;

    *)
        echo "Invalid arguments! ERROR encountered."
        exit 1
    esac
}

_proxy_help()
{
    cat<<__EOF__
    MESSAGE : In case of options, one value is displayed as the default value.
    Do erase it to use other value.

    There are the following options for this script:

    set    : Configure all settings, recommended (to configure)
    unset  : Remove proxy settings from all places
    sfew   : Apply proxy settings from selective locations
    ufew   : Unset proxy settings from selective locations
    q[quit]: Quit this program

__EOF__

}
_proxy_init()
{
    # create temporary files with extension .conf to be configured
    if [[ -e "$UPATH/utils/proxy/apt_config.config" && -e "$UPATH/utils/proxy/bash_set.config" ]]; then
        cp $UPATH/utils/proxy/apt_config.config $APT_CFG_FILE
        cp $UPATH/utils/proxy/bash_set.config $BASH_SET_CFG_FILE
    else
        echo "Required files are missing. Please check for files apt_config.bak and bash_set.bak" >&2
        exit 1
    fi

}

_proxy_set_proxy()
{

    _proxy_init && clear
    _proxy_help

    read -p "Enter your choice : " choice


    # take inputs and perform as necessary
    case "$choice" in

    set)
        _proxy_set_params "ALL"
        ;;

    unset)
        _proxy_unset_gsettings
        _proxy_unset_apt
        _proxy_unset_env
        ;;

    sfew)
        cat<<__EOF__
    Where do you want to set proxy?
    1 : Terminal only.
    2 : Desktop-environment/GUI and apps
    3 : APT/Software Center only
__EOF__
        read response

        case $response in
            1)
                _proxy_set_params "env"
                ;;
            2)
                _proxy_set_params "gsettings"
                ;;
            3)
                _proxy_set_params "apt"
                ;;
            *)
                echo "Invalid option."
                ;;
        esac

        ;;

    ufew)
        cat<<__EOF__
    Where do you want to unset proxy?
    1 : Terminal only.
    2 : Desktop-environment/GUI and apps
    3 : APT/Software Center only
__EOF__

        read
        case $REPLY in
            1)
                _proxy_unset_env
                ;;
            2)
                _proxy_unset_gsettings
                ;;
            3)
                _proxy_unset_apt
                ;;
            *)
                echo "Invalid arguments! Please retry."
                exit 1
                ;;

        esac

        ;;

    q|quit)
        echo "Quit!"
        exit 0
        ;;

    *)
        _proxy_help
        ;;
    esac

    rm $APT_CFG_FILE
    rm $BASH_SET_CFG_FILE
    echo "Done!"
}
