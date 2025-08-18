# My funny arch configuration
*Why is it funny you ask?*

Idk dude, you ask too many questions.

## What's in here?
Configuration files for my Arch setup:
- atuin
- hyprland
- kitty
- nvim
- rofi
- waybar
- zshrc
- grub
- sddm

There's also installed software/packages and troubleshooting steps.

## Theme
I'm currently using the [rose pine](https://rosepinetheme.com) theme and palette for almost everything.

## Installed stuff

### Pacman packages
```sh
# terminal
sudo pacman -Sy less fd ripgrep unzip fzf zoxide atuin

# clipboard:
sudo pacman -Sy wl-clipboard

# fonts:
sudo pacman -Sy ttf-font-awesome ttf-firacode-nerd noto-fonts-emoji noto-fonts-cjk ttf-liberation ttf-0xproto-nerd

# base programs:
sudo pacman -Sy steam discord obs-studio eog vlc

# Theme customization (dark mode and mouse cursor)
sudo pacman -Sy nwg-look

# razer (check https://openrazer.github.io/#download )
sudo pacman -Sy openrazer-daemon linux-headers python-openrazer

# Media control: 
sudo pacman -Sy playerctl

sudo pacman -Sy waybar

# Screenshots:
sudo pacman -Sy jq grim slurp hyprpicker hyprshot

# blue light filter: 
sudo pacman -Sy hyprsunset

# brightness control: 
sudo pacman -Sy ddcutil

# Bluetooth: 
sudo pacman -Sy bluez bluez-utils blueman

sudo pacman -Sy rustup

# hardware monitoring
sudo pacman -Sy lm-sensors amdgpu_top

sudo pacman -Sy stow

# Lock screen
sudo pacman -Sy hypridle hyprlock
```

### Yay packages
First check the yay github for install guide.

- opera (check troubleshooting section for video fix)

### Rust packages
```sh
# Markdown viewer
cargo install inlyne
```

### Mouse cursor 
https://rosepinetheme.com/themes/cursor/

### Zsh plugins and config
I use [ohmyzsh](https://github.com/ohmyzsh/ohmyzsh).

## Usage
To keep all of these config files in a single repository, you need to create symlinks for each package/app into their respective directory. 

I use [stow](https://www.gnu.org/software/stow/) to manage the symlinks.

1. Install stow with your package manager: `sudo pacman -S stow`
2. Use the `install.sh` script to create symlinks for each package.
    - You can also use `stow PACKAGE_NAME` to create a symlink for the desired package. 
        - Example: `stow nvim`. This will create a symlink for Neovim into `~/.config/nvim`.
    - Some packages add files outside of the home directory, so you need to specify the directory.
        - Example: `sudo stow grub -t /`

## Guides / Troubleshooting
I try to document any major problems that I have come across during my arch adventures and how to solve them. Maybe you'll find something useful here :)

### Run steam with wofi
Make `PrefersNonDefaultGPU=false` in .desktop file of Steam.

Related links:
- https://github.com/ValveSoftware/steam-for-linux/issues/9940
- https://github.com/ValveSoftware/steam-for-linux/issues/9383

### Playerctl not detecting apps as media players because of wofi
I had this issue where apps where not showing up as media players sometimes. The culprit was **wofi**.
When I launched apps with the terminal or by running the .desktop file directly with `dex` it worked perfectly.

wofi sometimes launches apps with different environment variables for some reason. One of these variables is the `DBUS_SESSION_BUS_ADDRESS`, which I think is related to the media player control.
wofi used a different bus address just because?

To test this, you can change the .desktop file (usually located at `/usr/share/applications`) of the application. Example with Firefox:
```
Exec=sh -c "env > /tmp/env_wofi.txt && /usr/lib/firefox/firefox %u"
```
Run the program (in this case Firefox), open the file (`vim /tmp/env_wofi.txt`) and check the env variables. Run `env` in another terminal and compare if `DBUS_SESSION_BUS_ADDRESS` is different.

You could try to fix it by adding the env variables to the Exec field of the .desktop file or something else. I honestly didn't try to fix it. At this point wofi gave me so many random problems that I gave up and installed [rofi-wayland](https://archlinux.org/packages/extra/x86_64/rofi-wayland/).

### Fix opera not playing video on X/Reddit/Twitch/etc
Issue where you can play video on some websites with opera (installed with yay).
Apparently opera installed with snap does not have this issue.

Possible fixes:
- Install this [yay package](https://aur.archlinux.org/packages/opera-ffmpeg-codecs): `yay -Syu opera-ffmpeg-codecs`
- https://github.com/Ld-Hagen/fix-opera-linux-ffmpeg-widevine

### Dark theme
Some apps like Dolphin or Nautilus will have light theme by default.

There are many ways to change this, like setting env variables.

This is what worked for me:
- Install nwg-look: `sudo pacman -Syu nwg-look`
- Open GTK Settings
- In the widgets sections, look for "Color scheme" and select Prefer dark
- (optional) Restart

### Mouse theme

If you installed a Mouse/Cursor theme but it's not working you can do the following:

- Install nwg-look
- Open GTK Settings
- Go to "Mouse Cursor" and select your icon theme
- Click "Apply"
- Restart

### Bluetooth dualboot
Yes, I use Windows (man I sure love anticheats).

If you have a Windows/Linux dualboot and you want to use Bluetooth devices on both
you will experience issues. You will have to repair devices every time you switch OS.

You could also experience weird issues where your network card stops working in Windows (**VERY** annoying, thanks Microsoft :D). I **highly** recommend disabling "fast startup" in windows to fix this. You can look up online how to disable it, but these are the general steps:
- Go to Control Panel > Power Options > Choose what the power buttons do.
- Click "Change settings that are currently unavailable."
- Uncheck "Turn on fast startup (recommended)."
- Save changes.

To avoid re-pairing, you need to sync the pairing keys (This guide is **not** for BT 5.1 devices. Check the resources below for more information).

1. Log into Linux (unpair your devices if they were already paired) and pair your devices.
2. Restart and log into Windows (unpair your devices if they were already paired) and pair your devices.
    - If you are having trouble removing a BT device, go into Device Manager -> Show -> Hidden devices
    - Remove greyed-out bluetooth devices.
    - Try removing your device again.
3. Restart and log into Linux.
4. Mount your windows partition.
    - Create a directory for the mount: `sudo mkdir /mnt/windows`
    - List your drives: `sudo fdisk -l`
    - Find a partition with type "Microsoft basic data". It should look similar to "/dev/nvme0n1pX"
    - Install ntfs-3g: `sudo pacman -Syu ntfs-3g`
    - Mount the partition: `sudo mount -t ntfs-3g /dev/nvme0n1p3 /mnt/windows`
5. Find the MAC address of your BT Adapter and BT device.
    - Run `sudo ls /var/lib/bluetooth/` to find the AdapterMAC.
    - You can use your prefered BT front-end (like Blueman) to find the DeviceMAC or run `sudo ls /var/lib/bluetooth/<AdapterMAC>` to list all Device MACs.
6. `cd /mnt/windows/Windows/System32/config`
7. `sudo chntpw -e SYSTEM`
8. Now you should be inside the windows registry. We need to extract the keys for each BT device.
    - `cd ControlSet001\Services\BTHPORT\Parameters\Keys`
    - Run `ls` and find the MAC address of your BT Adapter.
    - `cd <AdapterMAC>`
    - Run `ls` again and find the DeviceMAC
    - Run `hex <DeviceMAC>` and copy the key. It should look like: `55 BC 8B 59 33 50 78 E5 68 C5 B4 39 94 4F E1 U4`
9. Change the pairing key in Linux
    - Open the `info` file of your BT device: `sudo vim /var/lib/bluetooth/<AdapterMAC>/<DeviceMAC>/info`
    - Change the `Key` value in the `[LinkKey]` section with the key you copied from Windows **WITHOUT SPACES**.
        - Example `Key=55BC8B59335078E568C5B439944FE1U4`
10. Restart your computer.
11. Try connecting your BT device. It should work :)

Useful resources:
- https://wiki.archlinux.org/title/Bluetooth#Dual_boot_pairing
- https://github.com/nbanks/bluetooth-dualboot/issues/5
- https://github.com/nbanks/bluetooth-dualboot

### Disable a network interface/card
**Rant**: The network card that came with my motherboard (Realtek 8852CE) has been giving me tons of issues.
So I bought an Intel AX210 PCIe card, but now I have 2 network interfaces and I'm constantly confusing them.

To disable a network card, we are going to blacklist the kernel driver module from loading at boot:

1. Run `lspci -k` to see your pci devices + kernel drivers.
2. Search for "Network controller" and find the device that you want to disable.
3. Write down the kernel module. For example: `Kernel modules: rtw89_8852ce`.
4. Create a file like `/etc/modprobe.d/blacklist-networkcard.conf` and blacklist the module. Example:
```
# /etc/modprobe.d/blacklist-realtek.conf
blacklist rtw89_8852ce
```

5. Save the file and run `sudo mkinitcpio -P` to regenerate your initramfs.
6. Reboot.

> [!WARNING]
> You may need to reconfigure your WiFi connections to use `wlan0` if you were previously using `wlan1` or something else.

If you run `ip a show` you should see only one WiFi interface like `wlan0`.

### PS5 Controller touchpad acting as a Mouse
To disable this behavior follow this guide: https://wiki.archlinux.org/title/Gamepad#Disable_touchpad_acting_as_mouse

### Add Windows to GRUB
1. Install os-prober: `sudo pacman -Sy os-prober`

2. Run `sudo fdisk -l` and identify the EFI partition of Windows (e.g. "EFI System"). Take note of the partition name (e.g. "/dev/nvme0n1p1").
3. We need to mount the partition, so create a directory to mount it: `mkdir -p /mnt/windows`
4. Mount the partition: `sudo mount /dev/nvmeXnYpZ /mnt/windows`. (Use the actual name of your EFI partition)
5. Edit the file `/etc/default/grub` and add/uncomment `GRUB_DISABLE_OS_PROBER=false`.
6. Run `sudo grub-mkconfig -o /boot/grub/grub.cfg`. You should see the Windows boot manager in the output.

### Add a GRUB theme
First, get a theme. After you have a theme that you want to use:

1. Copy the theme into the themes directory: `sudo cp <path/to/your/theme> /boot/grub/themes/`
2. Add `GRUB_THEME="/boot/grub/themes/<YourTheme>/theme.txt"` in the `/etc/default/grub` file.

### Rearrange the GRUB menu entries
This method is semi-permanent. You will need to repeat these steps every time you run `grub-mkconfig`.

> [!WARNING]
> Use at your own risk.

1. Open the `/boot/grub/grub.cfg` file.
2. Look for the `menuentry` that you want to reorder.
3. Cut and paste it where you want it to be.
    - Entries are loaded in the order that they are specified.
    - Be careful to cut the entire section and paste it outside of the declaration of other entries.

## Useful commands

### Brightness and bluelight control
```sh
# Blue light
hyprctl hyprsunset temperature identity #default
hyprctl hyprsunset temperature 2500

# Brightness
ddcutil getvcp 10 # Get brightness
ddcutil setvcp 10 40 # Set brightness to 40
```

### zsh keybinds
Different keybind configs for zsh

```sh
bindkey -e # emacs (default)
bindkey -v # vi
