#!/bin/bash
# ProxyMan v1.7
# Author : Himanshu Shekhar < https://github.com/himanshushekharb16/ProxyMan >

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
# 02111-1307, USA.
#
# Tools used/required for implementation : bash, sed, grep, regex support, gsettings, apt
# and of-course privilege for setting up apt.
# The user should be in the sudoers to set up apt, or modify the script as required.
#
# Credits : https://wiki.archlinux.org/index.php/Proxy_settings
#           https://wiki.archlinux.org/index.php/Environment_variables
#           https://developer.gnome.org/ProxyConfiguration/
#           Alan Pope : https://wiki.ubuntu.com/AlanPope
#			The Linux Command Line, William E. Shotts
#           Ubuntu Forums
#           Stack Exchange
# and many more Google search links.
#
# This script sets the proxy configuration for a general system from the Debian family.
# Configures apt, environment variables and gsettings
# The Network Manager settings (native to Gnome), sets system-wide proxy settings
# but does not set up authentication
# which is not an issue except the case of apt, which does not work
# for authenticated proxy in this manner.
# Also, this script rules out the need of configuring proxy for apt separately.
# Also, as tested, it does not work for bash/Terminal.
# Thus, we need to configure not one but three things:
# gsettings, apt, and environment variables.
#
# ASSUMPTIONS :
# toggle checks current mode taking gsettings as default
#
# So, lets proceed.

#--------GLOBAL VARIABLES----------------
APT_CFG_FILE=$UPATH/utils/proxy/apt_config.conf
BASH_SET_CFG_FILE=$UPATH/utils/proxy/bash_set.conf
#--------FUNCTIONS------------------------

# function to configure environment variables
_proxy_config_env()
{
    # _proxy_config_env $http_host $http_port $use_auth $use_same $username $password $https_host $https_port $ftp_host $ftp_port $socks_host $socks_port
	if [[ $4 == 'y' ]]; then
		if [[ $3 == 'y' ]]; then
			sed -i "s/<PROXY>/$5\:$6\@$1\:$2/g" $BASH_SET_CFG_FILE
		else
			sed -i "s/<PROXY>/$1:$2/g" $BASH_SET_CFG_FILE
		fi
	elif [[ $4 == 'n' ]]; then
		if [[ $3 == 'y' ]]; then
			auth=$5:$6@
		else
			auth=''
		fi
		sed -i '/proxy\|proxy\|PROXY/d' $BASH_SET_CFG_FILE
		echo "http_proxy=$auth$1:$2" > $BASH_SET_CFG_FILE
		echo "HTTP_PROXY=$auth$1:$2" >> $BASH_SET_CFG_FILE
		echo "https_proxy=$auth$7:$8" >> $BASH_SET_CFG_FILE
		echo "HTTPS_PROXY=$auth$7:$8" >> $BASH_SET_CFG_FILE
		echo "ftp_proxy=$auth$9:$10" >> $BASH_SET_CFG_FILE
		echo "FTP_PROXY=$auth$9:$10" >> $BASH_SET_CFG_FILE
		echo "socks_proxy=$auth$11:$12" >> $BASH_SET_CFG_FILE
		echo "SOCKS_PROXY=$auth$11:$12" >> $BASH_SET_CFG_FILE
		read -e -p "Enter proxy settings for rsync in format host:port " -i $1:$2 rsync
		echo "rsync_proxy=$auth$rsync" >> $BASH_SET_CFG_FILE
		echo "RSYNC_PROXY=$auth$rsync" >> $BASH_SET_CFG_FILE
	fi

	if [[ $3 == "y" ]]; then # require authentication
		sed -i "s/<PROXY>/$4:$5@$1:$2/g" $BASH_SET_CFG_FILE
	else
		sed -i "s/<PROXY>/$1:$2/g" $BASH_SET_CFG_FILE
	fi

	if [[ -e "$HOME/.bashrc" ]]; then
		cat $BASH_SET_CFG_FILE >> $HOME/.bashrc
	fi
	if [[ -e "$HOME/.bash_profile" ]]; then
		cat $BASH_SET_CFG_FILE >> $HOME/.bash_profile
	fi

	read -p "modify /etc/environment ? (y/n)" -e
	if [[ $REPLY = 'y' ]]; then
		if [[ -e "/etc/environment" ]]; then
			sudo cat $BASH_SET_CFG_FILE >> "/etc/environment"
		else
			cat $BASH_SET_CFG_FILE > "/etc/environment"
		fi
	fi
}

_proxy_config_apt() {
#_proxy_config_apt $http_host $http_port $use_auth $use_same $username $password $https_host $https_port $ftp_host $ftp_port $socks_host $socks_port
	if [[ ! -e "/etc/apt" ]]; then
		echo "/etc/apt/ does not exist. Make sure apt is configured properly on this system."
		return 1
	fi
	if [[ ! -e "/etc/apt/apt.conf" ]]; then
		sudo touch "/etc/apt/apt.conf"
	fi
	echo $3:"Enter your System password (if asked)..."
	if [[ $3 == "n" ]]; then
		if [[ $4 == "y" ]]; then
			sed -i "s/<HOST>/$http_host/g" $APT_CFG_FILE
			sed -i "s/<PORT>/$http_port/g" $APT_CFG_FILE
			sed -i "s/<USERID>\:<PASSWORD>\@//g" $APT_CFG_FILE
		elif [[ $4 == "n" ]]; then
			echo Acquire\:\:Http\:\:Proxy\ \"http\:\/\/$1\:$2\/\"\; > $APT_CFG_FILE
			echo Acquire\:\:Https\:\:Proxy\ \"https\:\/\/$7\:$8\/\"\; >> $APT_CFG_FILE
			echo Acquire\:\:Ftp\:\:Proxy\ \"Ftp\:\/\/$9\:$10\/\"\; >> $APT_CFG_FILE
			echo Acquire\:\:Socks\:\:Proxy\ \"socks\:\/\/$11\:$12\/\"\; >> $APT_CFG_FILE
		else
			echo "Error!"
			exit 1
		fi
	elif [[ $3 == "y" ]]; then
		if [[ $4 == "y" ]]; then
			sed -i "s/<USERID>/$5/g" $APT_CFG_FILE
			sed -i "s/<PASSWORD>/$6/g" $APT_CFG_FILE
			sed -i "s/<HOST>/$1/g" $APT_CFG_FILE
			sed -i "s/<PORT>/$2/g" $APT_CFG_FILE
		else
			echo Acquire\:\:Http\:\:Proxy\ \"http\:\/\/$5\:$6\@$1\:$2\/\"\; > $APT_CFG_FILE
			echo Acquire\:\:Https\:\:Proxy\ \"https\:\/\/$5\:$6\@$7\:$8\/\"\; >> $APT_CFG_FILE
			echo Acquire\:\:Ftp\:\:Proxy\ \"ftp\:\/\/$5\:$6\@$9\:$10\/\"\; >> $APT_CFG_FILE
			echo Acquire\:\:Socks\:\:Proxy\ \"socks\:\/\/$5\:$6\@$11\:$12\/\"\; >> $APT_CFG_FILE
		fi
	else
		echo "Error encountered!"
		exit 1
	fi

	sudo cat ./$APT_CFG_FILE >> /etc/apt/apt.conf
}

_proxy_config_gsettings() {
# _proxy_config_gsettings $http_host $http_port $use_auth $use_same $username $password $https_host $https_port $ftp_host $ftp_port $socks_host $socks_port
	gsettings set org.gnome.system.proxy mode 'manual'
	if [[ $4 == "y" ]]; then
		gsettings set org.gnome.system.proxy use-same-proxy true
		gsettings set org.gnome.system.proxy.http enabled true
		gsettings set org.gnome.system.proxy.http host "'$1'";
		gsettings set org.gnome.system.proxy.http port "$2";
		gsettings set org.gnome.system.proxy.https host "'$1'"
		gsettings set org.gnome.system.proxy.https port "$2";
		gsettings set org.gnome.system.proxy.socks host "'$1'"
		gsettings set org.gnome.system.proxy.socks port "$2";
		gsettings set org.gnome.system.proxy.ftp host "'$1'"
		gsettings set org.gnome.system.proxy.ftp port "$2";
	else
		gsettings set org.gnome.system.proxy use-same-proxy false
		gsettings set org.gnome.system.proxy.http enabled true
		gsettings set org.gnome.system.proxy.http host "'$1'"
		gsettings set org.gnome.system.proxy.http port "$2"
		gsettings set org.gnome.system.proxy.https host "'$7'"
		gsettings set org.gnome.system.proxy.https port "$8"
		gsettings set org.gnome.system.proxy.socks host "'$11'"
		gsettings set org.gnome.system.proxy.socks port "$12"
		gsettings set org.gnome.system.proxy.ftp host "'$9'"
		gsettings set org.gnome.system.proxy.ftp port "$10"
	fi
	if [[ $3 == "y" ]]; then
		gsettings set org.gnome.system.proxy.http use-authentication true
		gsettings set org.gnome.system.proxy.http authentication-user "'$5'"
		gsettings set org.gnome.system.proxy.http authentication-password "'$6'"
	else
		gsettings set org.gnome.system.proxy.http use-authentication false
		gsettings set org.gnome.system.proxy.http authentication-user "''"
		gsettings set org.gnome.system.proxy.http authentication-password "''"
	fi
}

_proxy_unset_env() {
	# unset all environment variables from bash_profile and bashrc
	if [[ -e "$HOME/.bash_profile" ]]; then
		sed -i '/proxy\|PROXY\|Proxy/d' ~/.bash_profile
		sed -i '/ProxyMan/d' ~/.bash_profile
		sed -i '/github\.com/d' ~/.bash_profile
		sed -i '/Alan\ Pope/d' ~/.bash_profile
		sed -i '/end\ of\ proxy\ settings/d' ~/.bash_profile
	fi
	if [[ -e "$HOME/.bashrc" ]]; then
		sed -i '/proxy\|PROXY\|Proxy/d' ~/.bashrc
		sed -i '/ProxyMan/d' ~/.bashrc
		sed -i '/github\.com/d' ~/.bashrc
		sed -i '/Alan\ Pope/d' ~/.bashrc
		sed -i '/end\ of\ proxy\ settings/d' ~/.bashrc
	fi
	read -p "modify /etc/environment ? (y/n) " -e
	if [[ $REPLY = 'y' ]]; then
		# adding settings for /etc/environment
		if [[ -e "$HOME/.bashrc" ]]; then
			sudo sed -i '/proxy\|PROXY\|Proxy/d' /etc/environment
			sudo sed -i '/ProxyMan/d' /etc/environment
			sudo sed -i '/github\.com/d' /etc/environment
			sudo sed -i '/Alan\ Pope/d' /etc/environment
			sudo sed -i '/end\ of\ proxy\ settings/d' /etc/environment
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
		sudo sed -i '/Proxy/d' /etc/apt/apt.conf
	fi
}

_proxy_set_params() {
	echo "Set parameters received" $1
	echo "HTTP parameters : "
	read -p "Enter Host IP          : " http_host
	read -p "Enter Host Port        : " http_port
	read -e -p "Enable authentication (y/n)	: " use_auth
	if [[ $use_auth == 'y' ]]; then
		read -p "Enter Proxy Username   : " username
		echo -n "Enter password         : "
		read -s password
		echo
	fi
	read -e -p "Use the same values for all http, https, ftp, socks (y/n) : " use_same
	if [[ $use_same == 'n' ]]; then
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
	fi

	if [[ $1 == "ALL" ]]; then
		_proxy_config_apt $http_host $http_port $use_auth $use_same $username $password $https_host $https_port $ftp_host $ftp_port $socks_host $socks_port
		_proxy_config_gsettings $http_host $http_port $use_auth $use_same $username $password $https_host $https_port $ftp_host $ftp_port $socks_host $socks_port
		_proxy_config_env $http_host $http_port $use_auth $use_same $username $password $https_host $https_port $ftp_host $ftp_port $socks_host $socks_port
	elif [[ $1 -eq 1 ]]; then
		_proxy_config_env $http_host $http_port $use_auth $use_same $username $password $https_host $https_port $ftp_host $ftp_port $socks_host $socks_port
	elif [[ $1 -eq 2 ]]; then
		_proxy_config_gsettings $http_host $http_port $use_auth $use_same $username $password $https_host $https_port $ftp_host $ftp_port $socks_host $socks_port
	elif [[ $1 -eq 3 ]]; then
		_proxy_config_apt $http_host $http_port $use_auth $use_same $username $password $https_host $https_port $ftp_host $ftp_port $socks_host $socks_port
	else
		echo "Invalid arguments! ERROR encountered."
		exit 1
	fi
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
        _proxy_unset_gsettings
        _proxy_unset_env
        _proxy_set_params ALL
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
                _proxy_unset_env
                ;;
            2|3)
                _proxy_set_params $response
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
