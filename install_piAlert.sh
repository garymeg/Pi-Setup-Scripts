
# install prerequisites
sudo apt install apt-utils arp-scan dnsutils net-tools python3 -y
# install web/db components
sudo apt install lighttpd php php-cgi php-fpm php-sqlite3 sqlite3 -y
# clean apt package cache
sudo apt clean
# download the latest release
wget -O ./pialert.tar https://github.com/pucherot/Pi.Alert/raw/main/tar/pialert_latest.tar
# create target directory
sudo mkdir /var/www/pialert
# create logs directory
sudo mkdir /var/log/pialert
# extract the downloaded tar to /var/www/pialert
sudo tar xf ./pialert.tar -C /var/www/pialert --strip-components=1
# set the owner of the pialert directory
sudo chown -R www-data:www-data /var/www/pialert
# update pialert path in conf file
sed -i 's/\/home\/pi\/pialert/\/var\/www\/pialert/' /var/www/pialert/config/pialert.conf
# update pialert path in cron jobs
sed -i 's/python ~\/pialert\/back\/pialert.py/python3 \/var\/www\/pialert\/back\/pialert.py/g' /var/www/pialert/install/pialert.cron
# update log paths for cron jobs
sed -i 's/~\/pialert\/log\//\/var\/log\/pialert\//g' /var/www/pialert/install/pialert.cron
# create cronjob schedule
(crontab -l 2>/dev/null; cat /var/www/pialert/install/pialert.cron) | sudo crontab -
# create symbolic link to pialert
sudo ln -s /var/www/pialert/front/ /var/www/html/pialert
# copy pialert lighttpd conf
sudo cp /var/www/pialert/install/pialert_front.conf /etc/lighttpd/conf-available
# enable the pialert conf
sudo ln -s /etc/lighttpd/conf-available/pialert_front.conf /etc/lighttpd/conf-enabled/pialert_front.conf
# enable lighttpd fastcgi
sudo lighttpd-enable-mod fastcgi-php
# restart lighttpd service
sudo systemctl restart lighttpd













sudo nano /var/www/pialert/config/pialert.conf
# General Settings
# ----------------------
PIALERT_PATH               = '/home/pi/pialert'
DB_PATH                    = PIALERT_PATH + '/db/pialert.db'
LOG_PATH                   = PIALERT_PATH + '/log'
PRINT_LOG                  = False
VENDORS_DB                 = '/usr/share/arp-scan/ieee-oui.txt'
PIALERT_APIKEY             = ''
PIALERT_WEB_PROTECTION     = False
PIALERT_WEB_PASSWORD       = '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92'
NETWORK_DNS_SERVER         = 'localhost'
AUTO_UPDATE_CHECK          = True
AUTO_DB_BACKUP             = True
AUTO_DB_BACKUP_KEEP        = 5
REPORT_NEW_CONTINUOUS      = True
NEW_DEVICE_PRESET_EVENTS   = True
NEW_DEVICE_PRESET_DOWN     = True
SYSTEM_TIMEZONE            = 'Europe/Berlin'
OFFLINE_MODE               = False

# Other Modules
# ----------------------
SCAN_WEBSERVICES  = True
ICMPSCAN_ACTIVE   = True
SATELLITES_ACTIVE = False

# Special Protocol Scanning
# ----------------------
SCAN_ROGUE_DHCP        = False
DHCP_SERVER_ADDRESS    = '0.0.0.0'

# Custom Cronjobs
# ----------------------
# The shortest interval is 3 minutes. All larger intervals must be integer multiples of 3 minutes.
AUTO_UPDATE_CHECK_CRON = '0 3,9,15,21 * * *'
AUTO_DB_BACKUP_CRON    = '0 3 */2 * *'
REPORT_NEW_CONTINUOUS_CRON = '0 * * * *'
SPEEDTEST_TASK_CRON   = '00 7,22 * * *'

# Mail-Account Settings
# ----------------------
SMTP_SERVER       = 'smtp.gmail.com'
SMTP_PORT         = 587
SMTP_USER         = 'user@gmail.com'
SMTP_PASS         = 'password'
SMTP_SKIP_TLS	  = False
SMTP_SKIP_LOGIN	  = False

# WebGUI Reporting
# ----------------------
REPORT_WEBGUI              = True
REPORT_WEBGUI_WEBMON       = True
REPORT_TO_ARCHIVE          = 0
# Number of hours after which a report is moved to the archive. The value 0 disables the feature

# Mail Reporting
# ----------------------
REPORT_MAIL          = False
REPORT_MAIL_WEBMON   = False
REPORT_FROM          = 'Pi.Alert <' + SMTP_USER +'>'
REPORT_TO            = 'user@gmail.com'
REPORT_DEVICE_URL    = 'http://pi.alert/deviceDetails.php?mac='
REPORT_DASHBOARD_URL = 'http://pi.alert/'

# Pushsafer
# ----------------------
REPORT_PUSHSAFER         = False
REPORT_PUSHSAFER_WEBMON  = False
PUSHSAFER_TOKEN          = 'ApiKey'
PUSHSAFER_DEVICE         = 'a'
PUSHSAFER_PRIO           = 0
PUSHSAFER_SOUND          = 22

# Pushover
# ----------------------
REPORT_PUSHOVER         = False
REPORT_PUSHOVER_WEBMON  = False
PUSHOVER_TOKEN          = '<Token>'
PUSHOVER_USER           = '<User>'
PUSHOVER_PRIO           = 0
PUSHOVER_SOUND          = 'siren'

# ntfy
# ----------------------
REPORT_NTFY         = False
REPORT_NTFY_WEBMON  = False
NTFY_HOST           = 'https://ntfy.sh'
NTFY_TOPIC          = 'replace_my_secure_topicname_91h889f28'
NTFY_USER           = 'user'
NTFY_PASSWORD	    = 'password'
NTFY_PRIORITY 	    = 'default'
NTFY_CLICKABLE      = True

# Shoutrrr
# ----------------------
SHOUTRRR_BINARY    = 'armhf'
# SHOUTRRR_BINARY    = 'armhf'
# SHOUTRRR_BINARY    = 'arm64'
# SHOUTRRR_BINARY    = 'x86'

# Telegram via Shoutrrr
# ----------------------
REPORT_TELEGRAM         = False
REPORT_TELEGRAM_WEBMON  = False
TELEGRAM_BOT_TOKEN_URL  = '<Your generated servive URL for telegram - use $HOME/pialert/back/shoutrrr/<your Systemtyp>/shoutrrr generate telegram>'

# DynDNS
# ----------------------
QUERY_MYIP_SERVER = 'https://myipv4.p1.opendns.com/get_my_ip'
DDNS_ACTIVE       = False
DDNS_DOMAIN       = 'your_domain.freeddns.org'
DDNS_USER         = 'dynu_user'
DDNS_PASSWORD     = 'A0000000B0000000C0000000D0000000'
DDNS_UPDATE_URL   = 'https://api.dynu.com/nic/update?'

# Automatic Speedtest
# ----------------------
SPEEDTEST_TASK_ACTIVE = True

# Arp-scan Options & Samples
# ----------------------
ARPSCAN_ACTIVE  = True
MAC_IGNORE_LIST = []
IP_IGNORE_LIST  = []
SCAN_SUBNETS    = '--localnet'
# SCAN_SUBNETS    = '--localnet'
# SCAN_SUBNETS    = '--localnet --interface=eth0'
# SCAN_SUBNETS    = [ '192.168.1.0/24 --interface=eth0', '192.168.2.0/24 --interface=eth1' ]

# ICMP Monitoring Options
# ----------------------
ICMP_ONLINE_TEST  = 1
ICMP_GET_AVG_RTT  = 2

# Pi-hole Configuration
# ----------------------
PIHOLE_ACTIVE              = True
PIHOLE_VERSION             = 6
PIHOLE_DB                  = '/etc/pihole/pihole-FTL.db'
PIHOLE6_URL                = '192.168.2.253'
PIHOLE6_PASSWORD           = ''
PIHOLE6_API_MAXCLIENTS     = 200
DHCP_ACTIVE                = True
DHCP_LEASES                = '/etc/pihole/dhcp.leases'
DHCP_INCL_SELF_TO_LEASES   = True

# Fritzbox Configuration
# ----------------------
FRITZBOX_ACTIVE   = False
FRITZBOX_IP       = '192.168.17.1'
FRITZBOX_USER     = 'user'
FRITZBOX_PASS     = 'password'

# Mikrotik Configuration
# ----------------------
MIKROTIK_ACTIVE = False
MIKROTIK_IP     = '10.0.0.1'
MIKROTIK_USER   = 'user'
MIKROTIK_PASS   = 'password'

# UniFi Configuration
# -------------------
UNIFI_ACTIVE = False
UNIFI_IP     = '10.0.0.2'
UNIFI_API    = 'v5'
UNIFI_USER   = 'user'
UNIFI_PASS   = 'password'
# Possible UNIFI APIs are v4, v5, unifiOS, UDMP-unifiOS, default

# OpenWRT Configuration
# ----------------------
OPENWRT_ACTIVE            = False
OPENWRT_IP                = '192.168.1.1'
OPENWRT_USER              = 'root'
OPENWRT_PASS              = ''

# AsusWRT Configuration
# ----------------------
ASUSWRT_ACTIVE            = False
ASUSWRT_IP                = '192.168.1.1'
ASUSWRT_USER              = 'root'
ASUSWRT_PASS              = ''
ASUSWRT_SSL               = False

# Satellite Configuration
# -----------------------
SATELLITE_PROXY_MODE = False
SATELLITE_PROXY_URL = ''

# Maintenance Tasks Cron
# ----------------------
DAYS_TO_KEEP_ONLINEHISTORY = 120
DAYS_TO_KEEP_EVENTS = 360






