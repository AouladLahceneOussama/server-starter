#!/bin/bash

source Helpers/menu.sh
source Config/constant.sh

# Source all files in the Installer folder
for script in ./Packages/*.sh; do
    if [ -f "$script" ] && [ -x "$script" ]; then
        source "$script"
    fi
done

# Check requirements
check_requirements() {
    # check if the script is running as root
    if [ "$EUID" -ne 0 ]; then
        echo "Please run this script as root."
        exit 1
    fi
    
    # check if the script is running on a supported distribution
    if [ ! -f "/etc/os-release" ]; then
        echo "This script only supports distributions with /etc/os-release."
        exit 1
    fi
}

# Check the distribution
check_distribution() {
    DISTRIBUTION=$(lsb_release -si)
    VERSION=$(lsb_release -sr)

    # let's check if the distribution is in the list
    if [[ ! " ${DISTRIBUTIONS[@]} " =~ " ${DISTRIBUTION} " ]]; then
        echo "Your distribution is not supported by this script."
        exit 1
    fi

    # let's determine the package manager
    if [ -n "$(command -v apt)" ]; then
        PACKAGE_MANAGER="apt"
    elif [ -n "$(command -v yum)" ]; then
        PACKAGE_MANAGER="yum"
    else
        echo "Your package manager is not supported by this script."
        exit 1
    fi

    # let's print some information
    echo "System information:
    
    Distribution: $DISTRIBUTION
    Version: $VERSION
    Package manager: $PACKAGE_MANAGER"
    echo -e ""
}

# Checks
check_requirements 
check_distribution 

# Main Packages
install_php 
install_composer 
install_mysql
install_nginx
install_nodejs

# Extra packages
install_certbot
install_supervisor
install_cron


