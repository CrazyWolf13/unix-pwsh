sudo apt update
sudo add-apt-repository ppa:zhangsongcui3371/fastfetch -y
sudo apt update
sudo apt upgrade -y
sudo apt install nala btop screen -y
clear
echo "IP is: $(hostname -I | awk '{print $1}')"
echo "Hostname is: $(hostname)"
echo "Done!"