# Helpers
menu_from_array () {
    select item; do
        # Check the selected menu item number
        if [ "$REPLY" -ge 1 ] && [ "$REPLY" -le $# ]; then
            break;
        else
            echo "Wrong selection: Select any number from 1-$#"
        fi
    done
    
    echo "$item"
}
