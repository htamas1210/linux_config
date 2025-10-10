START_DIR=$(pwd)
echo "$START_DIR"

echo "Installing basic drivers and utilities"
sudo pacman -Sy
sudo pacman -S mesa sof-firmware zsh curl linux-firmware-marvell gcc man-db lib32-mesa openssh lib32-vulkan-intel vulkan-intel reflector power-profiles-daemon cpupower lib32-pipewire pipewire-audio pipewire-pulse pavucontrol git base-devel xdg-user-dirs --needed --noconfirm

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

echo "turning off grub timeout"
sudo nano /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg

echo "Installing hyprland and stuff for wm"
sudo pacman -S hyprland lua51 luarocks tmux hyprlock blueman zsh-autosuggestions zsh-syntax-highlighting network-manager-applet waybar yazi ffmpeg 7zip jq poppler fd ripgrep fzf zoxide resvg imagemagick ttf-jetbrains-mono-nerd ttf-jetbrains-mono ghostty swaync brightnessctl wireplumber xdg-desktop-portal-hyprland hyprpolkitagent qt5-wayland qt6-wayland hyprpaper xclip sddm rofi-wayland unzip make ripgrep fd neovim --needed --noconfirm
yay -S xwaylandvideobridge --needed --noconfirm
yay -S zen-browser-bin --needed --noconfirm

echo "Turining on sddm login manager"
sudo systemctl enable sddm

echo "Cloining kickstart nvim to nvim config location"
git clone https://github.com/htamas1210/kickstart-modular.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim

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
yay -S jellifin-media-player youtube-dl-gui --needed --noconfirm
sudo pacman -S steam nwg-displays calibre freecad obs-studio samba cmake feh --needed --noconfirm
sudo pacman -S wine wine-gecko wine-mono winetricks --needed --noconfirm

echo "Installing Oh my zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
cp "$START_DIR"/zsh/.zshcr $HOME/.zshrc
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
#wget https://raw.githubusercontent.com/zakaziko99/agnosterzak-ohmyzsh-theme/master/agnosterzak.zsh-theme
chsh -s $(which zsh)
