#!/bin/sh

_is_function()
{
    type $1 2>/dev/null | grep -i function > /dev/null && true
}

_die()
{
    echo $@ && exit 1
}

_has()
{
    type "$1" > /dev/null 2>&1
}

confirm()
{
    # call with a prompt string or use a default
    read -r -p "${1:-Are you sure (default NO)? [y/N]} " response
    case $response in
        [yY][eE][sS]|[yY])
            true
            ;;
        *)
            false
            ;;
    esac
}

_sudo_cmd()
{
    sudo sh -c "$*"
}
