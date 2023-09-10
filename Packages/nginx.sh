# install nginx
install_nginx() {
    echo "Installing nginx ..."

    # check if nginx is installed
    if [ -n "$(command -v nginx)" ]; then
        echo "nginx is already installed."
        setup_nginx
        return
    fi
    
    # let's construct command
    local nginx_installation_command="$PACKAGE_MANAGER install -y nginx"

    # let's install nginx
    echo "nginx installed successfully."

    # setup nginx
    setup_nginx
}

# setup nginx
setup_nginx() {
    echo "Setting up nginx ..."

    # let's change www-data in nginx config
    sudo sed -i "s/www-data/$CURRENT_USER/g" /etc/nginx/nginx.conf > /dev/null

    # allow 
    sudo ufw allow 'Nginx HTTP'

    # enable and start nginx
    sudo systemctl start nginx.service
    sudo systemctl enable nginx.service

    # verify nginx
    verify_command_output=$(systemctl status nginx | grep "active (running)" > /dev/null)
    if [ $? -eq 0 ]; then
        echo "nginx is active."
    else
        echo "nginx is not active."
    fi

    # let's check curl -I localhost
    checkcurl=$(curl -I localhost | grep "HTTP/1.1 200 OK" > /dev/null)
    if [ $? -eq 0 ]; then
        echo "nginx is running."
    else
        echo "nginx is not running."
    fi

    echo "nginx setup successfully."
}