#!/bin/sh

#**************************
#   BASIC FUNCTIONS       *
#**************************

msg()
{
    printf '%b\n' "$1" >&2
}

success()
{
    if [ "$ret" -eq '0' ]; then
       msg "\33[32m[✔]\33[0m ${1}${2}"
    fi
}

error()
{
    msg "\33[31m[✘]\33[0m ${1}${2}"
    exit 1
}

warning()
{
    msg "\33[33m[!]\33[0m ${1}${2}"
}


debug()
{
    if [ "$debug_mode" -eq '1' ] && [ "$ret" -gt '1' ]; then
        msg "ERROR in func \"${FUNCNAME[$i+1]}\" on line ${BASH_LINENO[$i+1]}."
    fi
}

program_exists()
{
    local ret='0'
    command -v $1 >/dev/null 2>&1 || { local ret='1'; }

    # fail on non-zero return value
    if [ "$ret" -ne 0 ]; then
        return 1
    fi

    return 0
}

program_must_exist()
{
    program_exists $1

    # throw error on non-zero return value
    if [ "$?" -ne 0 ]; then
        error "You must have '$1' installed to continue."
    fi
}

has()
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

