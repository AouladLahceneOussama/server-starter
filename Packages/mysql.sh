# install mysql
install_mysql() {
    echo "Choose MySQL version to install:"
    menu_from_array "${MYSQL_VERSIONS[@]}"
    echo "Installing MySQL $item ..."

    # check if mysql is installed
    if mysql --version 2>&1 | grep -q "^mysql"; then
        echo "MySQL $item is already installed."
        return
    fi
    
    # let's construct command
    local mysql_installation_command="sudo $PACKAGE_MANAGER install -y mysql-server-$item"

    # let's install MySQL
    sudo $mysql_installation_command
    echo "MySQL $item installed successfully."

    # setup mysql
    setup_mysql
}

# setup mysql
setup_mysql() {
    echo "Setting up MySQL ..."

    # enable and start mysql
    sudo systemctl start mysql.service

    # Change root password
    sudo mysql << EOF
        ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password'; 
        exit
EOF
    
    # setup mysql_secure_installation
    Mysql_root_password="password"

    sudo mysql_secure_installation << EOF
    
        y
        $Mysql_root_password
        $Mysql_root_password
        y
        y
        y
        y
EOF


    # revert user authentication
    mysql -u root -ppassword << EOF
        ALTER USER 'root'@'localhost' IDENTIFIED WITH auth_socket;
        exit
EOF

    # create user
    echo "Creating user ..."

    echo "Enter username:"
    read username

    echo "Enter password:"
    read -s password

	# create user
    mysql -u root -ppassword << EOF
        CREATE USER '$username'@'localhost' IDENTIFIED BY '$password';
        GRANT ALL PRIVILEGES ON *.* TO '$username'@'localhost' WITH GRANT OPTION;
        FLUSH PRIVILEGES;
        exit
EOF

    echo "MySQL setup successfully."
}