get_current_user() {
    if [ -n "$SUDO_USER" ]; then
        echo "$SUDO_USER"
    else
        echo "$USER"
    fi
}

DISTRIBUTIONS=("Ubuntu" "Debian" "CentOS" "Fedora")
PHP_VERSIONS=("7.4" "8.0" "8.1" "8.2")
PHP_LIBS=("cli" "common" "mysql" "zip" "gd" "mbstring" "curl" "xml" "bcmath" "redis" "ldap")
MYSQK_VERSIONS=("5.7" "8.0")

VERSION=""
PACKAGE_MANAGER=""
CURRENT_USER=$(get_current_user)