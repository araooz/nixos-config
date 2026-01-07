# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];


# Use the systemd-boot EFI boot loader.
  boot.loader = {
  efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot"; # O donde esté tu partición EFI
  };
  grub = {
    enable = true;
    device = "nodev"; # "nodev" es para instalaciones UEFI/EFI
    efiSupport = true;
    useOSProber = true; # <--- ESTO ES LO MÁS IMPORTANTE
  };
  systemd-boot.enable = false;
};


  networking.hostName = "nixos-btw";
  networking.networkmanager.enable = true;
  time.timeZone = "America/Lima";
  i18n.defaultLocale = "es_PE.UTF-8";
  
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  console = {
    font = "ter-v32b";
    keyMap = "la-latin1"; #us
  #   useXkbConfig = true; # use xkb.options in tty.
  };
 

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  services.xserver.xkb.layout = "latam"; #us

# Habilitar el login automático para el usuario falo
services.getty.autologinUser = "falo";
#y ejecutar hyprland de una
environment.loginShellInit = ''
  if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    exec Hyprland
  fi
'';


  users.users.falo = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio"];
    packages = with pkgs; [
      tree
      git
      kitty
      neovim
    ];
  };

  programs.firefox.enable = true;
  programs.hyprland.enable = true;
  programs.git.enable = true;

  # You can use https://search.nixos.org/ to find more packages (and options).
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    vim
    wget
    neovim
    kitty
    wget
    curl
    terminus_font
    hyprlock
    hyprpaper
    fastfetch
    waybar
    rofi
    zapzap
    easyeffects
    os-prober
    unzip
#audio y brillo
    pavucontrol
    playerctl
    blueman
    bluez
    pamixer
    brightnessctl
    glib
#dolphin
    kdePackages.dolphin
    kdePackages.qtwayland        # Soporte nativo para Wayland
    kdePackages.qtsvg            # Para que los iconos se vean bien
    kdePackages.kio-extras       # Miniaturas y funciones extra
    adwaita-qt                   # Tema para que apps Qt parezcan de GNOME/Modernas (opcional)
    libsForQt5.qtstyleplugin-kvantum # Si quieres temas muy personalizados
    libsForQt5.qt5ct
    kdePackages.qt6ct
    adwaita-qt6
#imagenes y capturas
    grim
    slurp
    imv
    wl-clipboard
# lenguajes
    gcc
    gnumake
    python3
    nodejs
    nodePackages.intelephense
    typescript-language-server # (ts_ls)
    vscode-langservers-extracted # (eslint)
    pyright
  ];

#audio
  services.pipewire = {
    enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true; 
  };
#bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
#lo de dolphin
xdg.portal = {
  enable = true;
  config.common.default = "*";
  extraPortals = [ pkgs.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal-gtk ];
};





#fuentes
  fonts.fontconfig.enable = true;
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.ubuntu-mono
    font-awesome
  ];

# modo oscuro
  qt.enable = true;
  qt.platformTheme = "qt5ct";

# Esto ayuda a que las apps GTK3/4 sepan que prefieres el modo oscuro
#  environment.sessionVariables = {
#    GTK_THEME = "Adwaita:dark";
#    ADW_DISABLE_PORTAL = "1";
#    # Forzar que Qt use la configuración que acabas de guardar
#    QT_QPA_PLATFORMTHEME = "qt6ct"; 
#    # Opcional: Ayuda a que Dolphin se vea mejor en Wayland
#    QT_QPA_PLATFORM = "wayland";
#  };

#para que nixos pueda ejecutar binarios externos (mason)
  programs.nix-ld.enable = true;


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  

  nix.settings.auto-optimise-store = true;



  system.stateVersion = "25.11"; # Did you read the comment?
}



