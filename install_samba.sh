
clear
echo ""
echo "Installing Samba for file sharing..."
echo " "
#sudo apt-get install samba samba-common-bin
 
# Config : 
# sudo nano /etc/samba/smb.conf
# Turn on : Wins Support = yes
# workgroup = WORKGROUP
clear
echo ""
echo "Setting up Samba user password"
echo "recomend to use pi user password for simplicity"
echo ""
wait
#sudo smbpasswd -a pi
 
#Make Share :
echo ""
echo "Creating shared directory at /home/pi/Documents/piShare"
echo ""
sudo mkdir -p -m 0777 /home/pi/Documents/piShare

#Config : sudo nano /etc/samba/smb.conf
#Scroll To Bottom
echo ""
echo "Adding Samba share configuration to /etc/samba/smb.conf"
echo ""
# Append the share configuration to the smb.conf file

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