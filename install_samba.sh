

sudo apt-get install samba samba-common-bin

# Config : 
# sudo nano /etc/samba/smb.conf
# Turn on : Wins Support = yes
# workgroup = WORKGROUP

sudo smbpasswd -a pi

#Make Share :
mkdir -p Documents/piShare
cd ${home}/Documents
sudo mkdir -m 0777 piShare

#Config : sudo nano /etc/samba/smb.conf
#Scroll To Bottom

sudo tee -a /etc/samba/smb.conf > /dev/null <<EOT
[piShare]
   comment= Pi Share
   path=/home/pi/Documents/piShare
   browseable=yes
   writeable=yes
   only guest=no
   create mask=0777
   directory mask=0777
   public=no 
   #(or yes if no login required)
EOT
# Restart Samba Service
sudo systemctl restart smbd