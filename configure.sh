START_DIR=$(pwd)
echo "$START_DIR"

echo "Installing basic drivers and utilities"
sudo pacman -Sy
sudo pacman -S fakeroot debugedit mesa sof-firmware zsh curl linux-firmware-marvell gcc man-db lib32-mesa openssh reflector vulkan-radeon power-profiles-daemon cpupower lib32-pipewire pipewire-audio pipewire-pulse pavucontrol git base base-devel xdg-user-dirs --needed --noconfirm

#create the user folders
xdg-user-dirs-update

cpu_vendor=$(lscpu | grep "Vendor ID" | awk '{print $3}')

if [[ "$cpu_vendor" == "AuthenticAMD" ]]; then
    echo "Detected AMD CPU — installing amd-ucode..."
    sudo pacman -S amd-ucode --needed --noconfirm
    sleep 3
elif [[ "$cpu_vendor" == "GenuineIntel" ]]; then
    echo "Detected Intel CPU — installing intel-ucode..."
    sudo pacman -S intel-ucode --needed --noconfirm
else
    echo "⚠️  No supported CPU vendor detected."
    echo "No CPU matched (Vendor ID: $cpu_vendor)"
    exit 1
fi

echo "Enabling reflector service for mirror optimization"
sudo systemctl enable reflector

echo "Installing yay"
git clone https://aur.archlinux.org/yay-bin.git $HOME/yay
sleep 2

cd $HOME/yay/
makepkg -si
cd
sleep 2

echo "Yay sync"
yay -Sy

sleep 3
echo "turning off grub timeout"
chmod 777 $START_DIR/grub/grub.sh
bash $START_DIR/grub/grub.sh

#sudo nano /etc/default/grub
#sudo grub-mkconfig -o /boot/grub/grub.cfg

echo "Installing hyprland and stuff for wm"
sudo pacman -S hyprland glow starship lua51 luarocks tmux hyprlock npm nodejs bluez bluez-utils btop docker docker-compose gradle gst-plugin-pipewire gvfs-smb htop hyprshot blueman network-manager-applet waybar yazi ffmpeg 7zip jq poppler fd ripgrep fzf zoxide resvg imagemagick ttf-jetbrains-mono-nerd ttf-jetbrains-mono ghostty swaync brightnessctl wireplumber xdg-desktop-portal-hyprland hyprpolkitagent qt5-wayland qt6-wayland hyprpaper xclip sddm rofi-wayland unzip make ripgrep fd neovim dotnet-runtime dotnet-sdk aspnet-runtime jdk-openjdk openjdk-doc libpulse mono nano nemo networkmanager-openvpn nmap opencv openssl openvpn pipewire pipewire-alsa pipewire-jack vlc vlc-plugins-all wget curl zram-generator --needed --noconfirm
sudo pacman -S hyprcursor hyprgraphics hyprland hyprland-guiutils hyprland-qt-support hyprlang hyprlock hyprpaper hyprpolkitagent hyprpwcenter hyprqt6engine hyprqt6engine-debug hyprshot hyprtoolkit hyprutils hyprwayland-scanner hyprwire xdg-desktop-portal-hyprland --needed --noconfirm
sudo pacman -S --needed --noconfirm baobab blender gnome-disk-utility gnome-text-editor libreoffice-fresh virtualbox virtualbox-guest-iso virtualbox-host-modules-arch bear clang gdb lazygit mariadb-clients mingw-w64-gcc openmpi podman python-pip raylib valgrind dos2unix rsync tree xboxdrv zip 
#yay -S xwaylandvideobridge --needed --noconfirm
yay -S zen-browser-bin --needed --noconfirm
yay -S unityhub --needed --noconfirm

#.bashrc line for starship
echo 'eval "$(starship init bash)"' >> $HOME/.bashrc

echo "Turining on sddm login manager"
sudo systemctl enable sddm

echo "Cloining kickstart nvim to nvim config location"
git clone http://rpiserver.ddns.net:3000/htamas1210/kickstart-modular.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim

echo "Installing rust and go and bootdev cli"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
curl -sS https://webi.sh/golang | sh; source ~/.config/envman/PATH.env
go install github.com/bootdotdev/bootdev@latest
curl -sS https://webi.sh/gh | sh; source ~/.config/envman/PATH.env

mkdir -p $HOME/.config/hypr/
cp "$START_DIR"/hypr/* $HOME/.config/hypr/ -r

#hyprpaper and conf
mkdir -p $HOME/Pictures/Wallpaper/ 
git clone https://github.com/htamas1210/Wallpapers.git $HOME/Pictures/Wallpaper/
printf "splash = true\nipc = on" > $HOME/.config/hypr/hyprpaper.conf 

#waybar
mkdir -p $HOME/.config/waybar/
cp "$START_DIR"/waybar/* $HOME/.config/waybar -r

#rofi
mkdir -p .config/rofi
cp "$START_DIR"/rofi/* $HOME/.config/rofi/ -r

#apps
yay -S jellifin-media-player youtube-dl-gui jetbrains-toolbox sddm-silent-theme --needed --noconfirm
yay -S --needed --noconfirm rpi-imager dirb wordlists

echo "Setting up sddm silent theme"
sudo echo "    # Make sure these options are correct:
    [General]
    InputMethod=qtvirtualkeyboard
    GreeterEnvironment=QML2_IMPORT_PATH=/usr/share/sddm/themes/silent/components/,QT_IM_MODULE=qtvirtualkeyboard

    [Theme]
    Current=silent" > /etc/sddn.conf

#xbox controller fix
echo 1 | sudo tee /sys/module/bluetooth/parameters/disable_ertm

sudo pacman -S steam nwg-displays calibre freecad obs-studio samba cmake feh --needed --noconfirm
sudo pacman -S wine wine-gecko wine-mono winetricks --needed --noconfirm
yay -S rustdesk --needed --noconfirm

#echo "Installing Oh my zsh"
#sudo pacman -S --needed --noconfirm zsh-autosuggestions zsh-syntax-highlighting
#sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
#cp "$START_DIR"/zsh/.zshcr $HOME/.zshrc
#git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
#git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
#wget https://raw.githubusercontent.com/zakaziko99/agnosterzak-ohmyzsh-theme/master/agnosterzak.zsh-theme
#chsh -s $(which zsh)
