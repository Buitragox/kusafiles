# TODO list
- [x] Remove mouse acceleration
- [x] Install neovim
- [ ] Map rctrl to caps lock. Look into keyd (https://medium.com/@mynameised/using-keyd-in-hyprland-to-rebind-your-right-alt-key-to-escape-linux-782086c81c75) 
- [x] Install zsh and OMZ.
- [x] Install a different terminal.
    - Wezterm (had to disable wayland)
    - Ghostty (didn't try it)
    - I settled with kitty for now.
- [ ] Install obsidian
- [x] Install Steam and play a windows game.
- [x] App launcher
  - Installed rofi for now
  - wofi gave me tons of headaches.
  - Explored options: tofi, kupfer (looks old), fuzzel
  - [ ] Explore [albert](https://albertlauncher.github.io)
- [ ] Waybar with volume, workspaces, mouse battery.
    - Had to install FiraCode nerd font and FontAwesome (use the arch ttf-font-awesome)
    - [ ] Screen brightness (need ddcutil)
    - [x] Mouse battery (mouse icon, percentaje). How often does it run?
    - [x] pavucontrol (media control)
    - [x] Add media player
    - [ ] What's the scratchpad?
    - [x] Highlight active directory
    - [x] What's idle inhibitor?
    - [x] Whats the eye icon/button?
    - [x] Show correct cpu temp
    - [x] Fix power button crashing waybar
- ~[ ] Customize wezterm~
- [x] Fix opera font and icons
- [ ] Automate night light
- [x] Customize cursor theme
- [ ] Customize fastfetch
- [ ] Customize the greeter
- [ ] Change the zsh theme

# Future sidequests

- [ ] (Actually not insane) Create dpi change notification daemon
  - Check how to create a daemon (what's actually a daemon?). Can you just do it in python?
  - Check for dpi changes.
  - After creating it with a repo, submit an issue to openrazer to see if it would be nice to add it?

- [ ] Create a brightness app/cli.
  - You could select which monitor you want to change the brightness of.
  - Could also select all monitors or select a few?
  - Problem: Not all monitors are created equal, maybe add a way to change the brightness in different ways?
  - Add presets: you can select a brightness config for each monitor with a name. (Day, Afternoon, Night)
  - Maybe add a rofi plugin?

- [ ] Night light schedule
  - Maybe contribute to hyprsunset to be able to schedule the blue light?
    - This sounds like a painful C++ sidequest.

- [ ] Create rose-pine albert theme if I prefer albert.
  1. Double check that it doesn't exists already.
  2. Create the theme for albert (probably just colors?) (can't define colors in qss)
  3. Raise an issue? to rose-pine

- [ ] Make a simple wayland compositor?

