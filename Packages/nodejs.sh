# node js
install_nodejs() {
    echo "Installing nodejs ..."

    # check if nodejs is installed
    if [ -n "$(command -v node)" ]; then
        echo "nodejs is already installed."
        return
    fi

    # let's construct command
    curl -sL https://deb.nodesource.com/setup_18.x -o nodesource_setup.sh > /dev/null
    chmod +x nodesource_setup.sh
    sudo bash nodesource_setup.sh
    sudo apt install nodejs -y
    rm nodesource_setup.sh

    echo "nodejs installed successfully."
}