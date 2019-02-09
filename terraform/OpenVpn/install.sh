    echo "########################################################"
    echo "### Install Software ###################################"
    echo "########################################################"
    apt-get update -y
  
    sudo apt-get install -y \
        ntp \
        wget \
        curl

    wget http://swupdate.openvpn.org/as/openvpn-as-2.6.1-Ubuntu16.amd_64.deb
    dpkg -i openvpn-as-2.6.1-Ubuntu16.amd_64.deb

    echo "########################################################"
    echo "### Configure Software #################################"
    echo "########################################################"
    sudo service openvpnas stop
    rm -f /usr/local/openvpn_as/etc/db/config.db
    rm -f /usr/local/openvpn_as/etc/db/certs.db
    rm -f /usr/local/openvpn_as/etc/db/userprop.db
    rm -f /usr/local/openvpn_as/etc/db/log.db
    rm -f /usr/local/openvpn_as/etc/as.conf
    /usr/local/openvpn_as/bin/sqlite3 < /tmp/OpenVpn/config.db.bak /usr/local/openvpn_as/etc/db/config.db
    /usr/local/openvpn_as/bin/sqlite3 </tmp/OpenVpn/certs.db.bak /usr/local/openvpn_as/etc/db/certs.db
    /usr/local/openvpn_as/bin/sqlite3 </tmp/OpenVpn/userprop.db.bak /usr/local/openvpn_as/etc/db/userprop.db
    /usr/local/openvpn_as/bin/sqlite3 </tmp/OpenVpn/log.db.bak /usr/local/openvpn_as/etc/db/log.db
    cp /tmp/OpenVpn/as.conf.bak /usr/local/openvpn_as/etc/as.conf
    sudo service openvpnas start

    echo "done"