#!/bin/sh

PKG="u-cli"
GIT_URL="https://github.com/ujnzxw/u-cli.git"
INSTALL_DIR="${INSTALL_DIR}"


has()
{
    type "$1" > /dev/null 2>&1
}



install_from_git()
{
    [ -z "${INSTALL_DIR}" ] && INSTALL_DIR="/usr/local/${PKG}"
    if [ -e "${INSTALL_DIR}" ]; then
        echo "${PKG} Is already installed"
        echo "Updating ${PKG} from git"
        command git --git-dir="${INSTALL_DIR}/.git" --work-tree="${INSTALL_DIR}" fetch --depth=1 ||
        {
            echo >&2 "Failed to fetch changes => ${GIT_URL}"
            exit 1
        }
        command git --git-dir="${INSTALL_DIR}/.git" --work-tree="${INSTALL_DIR}" reset --hard origin/master ||
        {
            echo >&2 "Failed to reset changes => ${GIT_URL}"
            exit 1
        }
    else
        echo "Downloading ${PKG} from git to ${INSTALL_DIR}"
        command git clone --depth 1 ${GIT_URL} ${INSTALL_DIR} ||
        {
            echo >&2 "Failed to clone => ${GIT_URL}"
            exit 1
        }
        chmod -R 755 ${INSTALL_DIR}/lib  2>/dev/null
        chmod -R 755 ${INSTALL_DIR}/plugins 2>/dev/null
        chmod 755 ${INSTALL_DIR}/u 2>/dev/null
        sudo ln -sf ${INSTALL_DIR}/u /usr/local/bin/u
    fi
}

# Check if /bin/sh is linked to /bin/bash
command ls -l /bin/sh | grep bash > /dev/null 2>&1 ||
{
	echo >&2 "/bin/sh is not linked to /bin/bash"
	echo >&2 "Please use ln to link it first!"
	exit 1
}

if has "git"; then
    install_from_git;
else
    echo >&2 "Failed to install, please install git before."
fi

[ -z "${INSTALL_DIR}" ] && INSTALL_DIR="/usr/local/${PKG}"

if [ -f "${INSTALL_DIR}/m" ]; then
    echo ""
    echo "Done!"
else
    echo >&2 ""
    echo >&2 "Something went wrong. ${INSTALL_DIR}/u not found"
    echo >&2 ""
    exit 1
fi

# vim: set ts=4 sw=4 softtabstop=4 expandtab
