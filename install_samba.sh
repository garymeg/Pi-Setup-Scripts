
clear
echo ""
echo "Installing Samba for file sharing..."
echo " "
sudo apt-get update
sudo apt-get install samba samba-common-bin
 
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
sudo smbpasswd -a -n pi

echo "samba password set to no password"
echo "please change the password to something secure"
echo "use 'sudo smbpasswd -U "pi"' to change it later"

#Make Share :
echo ""
echo "Creating shared directory at /home/pi/Documents/Share"
echo ""
sudo mkdir -p -m 0777 /home/pi/Documents/Share

#Config : sudo nano /etc/samba/smb.conf
#Scroll To Bottom
echo ""
echo "Adding Samba share configuration to /etc/samba/smb.conf"
echo ""
# Append the share configuration to the smb.conf file

sudo tee -a /etc/samba/smb.conf > /dev/null <<EOT
[Share]
   comment= Shared Network Directory
   path=/home/pi/Documents/Share
   browseable=yes
   writeable=yes
   only guest=no
   create mask=0777
   directory mask=0777
   public=no 
   #(or yes if no login required)

[RaspberryPi]
   comment= Shared Network Directory
   path=/
   browseable=yes
   writeable=yes
   only guest=no
   create mask=0777
   directory mask=0777
   public=no 
EOT
# Restart Samba Service
sudo systemctl restart smbd
echo "Samba service is now running and the share is set up."
