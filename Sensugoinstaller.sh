#!/bin/sh -e
_check_root () {
    if [ $(id -u) -ne 0 ]; then
        echo -e "\e[1;31mPlease run as root\e[0m" >&2;
        exit 1;
    fi
         echo -e "\e[1;34mThis Script will install Sensu Commercial Package to your system\e[0m"

} 

_install_curl_wget () {
    if [ -x "$(command -v curl)" ]; then
        return
    fi

    if [ -x "$(command -v apt-get)" ]; then
        apt-get update
        apt-get -y install curl wget
    elif [ -x "$(command -v yum)" ]; then
        yum -y install curl wget
    else
        echo "No known package manager found" >&2;
        exit 1;
    fi

}

_install_sensu () {
    if [ -x "$(command -v yum)" ]; then
        echo "OS Version is $(cat /etc/redhat-release | awk '{print $1}')"
        echo "Adding the Sensu Backend repo"
        if [ -e "/tmp/script.rpm.sh" ]; then
        echo "Script present localy"
        else
        cd /tmp && wget https://packagecloud.io/install/repositories/sensu/stable/script.rpm.sh && sudo bash script.rpm.sh > /dev/null
        fi
        echo "Installing the Sensu Backend"
        yum install sensu-go-backend
        systemctl start sensu-backend && systemctl enable sensu-backend && systemctl status sensu-backend
        echo "Copying the backend skeleton file"
        sudo curl -L https://docs.sensu.io/sensu-go/latest/files/backend.yml -o /etc/sensu/backend.yml
        echo "Installing the Sensuctl"
        curl https://packagecloud.io/install/repositories/sensu/stable/script.rpm.sh | sudo bash && yum install sensu-go-cli
               
    fi

}

_check_root
_install_curl_wget
_install_sensu
