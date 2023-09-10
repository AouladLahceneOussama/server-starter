# install certbot
install_certbot() {
    echo "Installing certbot ..."

    # check if certbot is installed
    if [ -n "$(command -v certbot)" ]; then
        echo "certbot is already installed."
        return
    fi

    # let's construct command
    local certbot_installation_command="$PACKAGE_MANAGER install -y certbot python3-certbot-nginx"
    sudo $certbot_installation_command

    echo "certbot installed successfully."
}

# install supervisor
install_supervisor() {
    echo "Installing supervisor ..."

    # check if supervisor is installed
    if [ -n "$(command -v supervisorctl)" ]; then
        echo "supervisor is already installed."
        return
    fi

    # let's construct command
    local supervisor_installation_command="$PACKAGE_MANAGER install -y supervisor"
    sudo $supervisor_installation_command

    echo "supervisor installed successfully."
}

# install cron
install_cron() {
    echo "Installing cron ..."

    # check if cron is installed
    if [ -n "$(command -v cron)" ]; then
        echo "cron is already installed."
        return
    fi

    # let's construct command
    local cron_installation_command="$PACKAGE_MANAGER install -y cron"
    sudo $cron_installation_command

    # let's enable cron
    sudo systemctl enable cron

    echo "cron installed and enabled successfully."
}
