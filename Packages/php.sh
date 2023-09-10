# Install PHP
install_php() {
	echo "Choose PHP version to install:"
    menu_from_array "${PHP_VERSIONS[@]}"
    echo "Installing PHP $item ..."
        
    # check if php version is already installed
    if [ -d "/etc/php/$item" ]; then
        echo "PHP $item is already installed."
        setup_php
        return
    fi
    
    # let's construct command
    local php_installation_command="$PACKAGE_MANAGER install -y php$item"
    for PHP_LIB in "${PHP_LIBS[@]}"; do
        php_installation_command="$php_installation_command php$item-$PHP_LIB"
    done
    
    # let's prepare for installation
    sudo $PACKAGE_MANAGER update
    sudo $PACKAGE_MANAGER install -y software-properties-common
    sudo add-apt-repository ppa:ondrej/php -y
    sudo $PACKAGE_MANAGER update

    # let's install PHP
    sudo $php_installation_command
    
    # let's setup PHP
   	setup_php
}

# setup php
setup_php() {
    echo "Setting up PHP ..."

    # enable and start php
    sudo systemctl start php$item-fpm.service > /dev/null 2>&1
    sudo systemctl enable php$item-fpm.service > /dev/null 2>&1

    # let's change www-data in php-fpm pool
    sudo sed -i "s/www-data/$CURRENT_USER/g" /etc/php/$item/fpm/pool.d/www.conf > /dev/null
    
    echo "setup PHP is done"
}

# install composer
install_composer() {
    echo "Installing composer ..."

    # check if curl is installed
    if [ -z "$(command -v curl)" ]; then
        sudo $PACKAGE_MANAGER install -y curl
    fi
    
    # donwload and install composer
    curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php
    local HASH=`curl -sS https://composer.github.io/installer.sig`
    php -r "if (hash_file('SHA384', '/tmp/composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); exit(1);} echo PHP_EOL;"
    sudo php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer

    echo "Composer installed successfully."
}