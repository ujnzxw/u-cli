#!/bin/sh

. $UPATH/lib/functions.sh

# shutdown/poweroff
_sys_force_shutdown()
{
    _sudo_cmd poweroff
}

_sys_graceful_shutdown()
{
    gnome-session-quit --reboot
}

# reboot
_sys_force_reboot()
{
    _sudo_cmd reboot
}
_sys_graceful_reboot()
{
    gnome-session-quit --reboot
}

# sleep
_sys_force_sleep()
{
    _sudo_cmd pm-suspend
}

# wallpaper
_sys_set_wallpaper()
{
    [ -z "$1" ] && echo "No file!"  && exit 1
    uri="file://$1"
    gsettings set org.gnome.desktop.background picture-uri $uri
}

# system info
_sys_system_hw_info()
{
    _sudo_cmd dmidecode -q | more
}

_sys_system_sw_info()
{
    lsb_release -a
}

# trash
_sys_trash_cli_chk()
{
    if _has trash-list; then
        continue
    else
        echo "trash-cli is not installed, install it now?"
        if confirm; then
            clear
            echo "start to install trash-cli..."
            _sudo_cmd apt-get install trash-cli
            if _has trash-list; then

                echo "Done. Please re-run your command :)"
                exit 0
            else
                echo "ERROR encountered! Please have a check!"
                exit 1
            fi
        else
            echo "CMD \"u trash\" cannot be used without trash-cli :("
            exit 1
        fi
    fi
}

_sys_trash_clean()
{
    trash-empty
}

_sys_trash_status()
{
    #[ -z "$1" ] && echo "No file!"  && exit 1
    trash-list

}
_sys_trash_put()
{
    [ -z "$1" ] && echo "No file!"  && exit 1
    trash-put $@

}
_sys_trash_list()
{
    #[ -z "$1" ] && echo "No file!"  && exit 1
    trash-list

}
_sys_trash_clean()
{
#    [ ! -e "$HOME/.Trash"  ] && echo "Trash not found" && exit 1
    [ -z "$1" ] && echo "No file!"  && exit 1
    trash-empty
}
_sys_trash_restore()
{
    [ -z "$1" ] && echo "No file!"  && exit 1
    trash-restore
}

# network related
_sys_show_ip()
{
    case $1 in

       a|all)
           netstat -tn 2>/dev/null
       ;;
       *)
           netstat -tn 2>/dev/null \
           | grep tcp              \
           | grep \\.              \
           | awk '{print $4}'      \
           | cut -d: -f1           \
           | sort                  \
           | uniq -c               \
           | sort -nr              \
           | head                  \
           | awk '{print $2}'
       ;;
    esac
}
