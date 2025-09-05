# Check if stow is installed
if ! command -v stow >/dev/null 2>&1; then
  echo "stow is not installed. Install it with:\nsudo pacman -Sy stow"
fi

# Standard stuff
stow atuin delta hypr kitty nvim rofi waybar zsh

# Packages that work outside of home directory
sudo stow grub sddm -t /

sudo cp -r ./sddm-themes/sddm-astronaut-theme /usr/share/sddm/themes

# Can't create symlinks to /boot, so we copy paste
sudo cp -r ./grubthemes/MilkGrub /boot/grub/themes
