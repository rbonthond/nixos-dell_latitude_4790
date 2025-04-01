# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

  # Enable flakes
  nix.package = pkgs.nixVersions.latest;
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.tmp.cleanOnBoot = true;

  # Security
  nix.settings.trusted-users = ["root" "robbin"];
  security.sudo.wheelNeedsPassword = false;

  # Store
  nix.gc.automatic = true;
  nix.optimise.automatic = true;
  nix.settings.auto-optimise-store = true;

  # Networking
  networking.hostName = "nixos"; # Define your hostname.
  #networking.wireless = {
  #  enable = true;
  #  userControlled.enable = true;
  #  networks = {
  #      "bonthond" = {
  #        pskRaw = "4b1884c6f79c3d5ad7dece5c0cfd6e5a9cac3b3d567761ffa919b3da39c26bd1";
  #      };
  #  };
  #};

  # Configure network proxy if necessary
  #networking.proxy.default = "http://user:password@proxy:port/";
  #networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # enable opengl support
  hardware.graphics.enable = true;

  # enable netdata
  services.netdata = {
    enable = true;
    config = {
      global = {
      };
      ml = {
        "enabled" = "yes";
      };
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.robbin = {
    isNormalUser = true;
    description = "Robbin Bonthond";
    extraGroups = ["networkmanager" "wheel"];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    curl
    vim
    git
    just
  ];

  # Enable sound
  nixpkgs.config.pulseaudio = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [pkgs.cnijfilter2];
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;

  # Virtualbox
  #virtualisation.virtualbox.host.enable = true;
  #virtualisation.virtualbox.host.enableExtensionPack = true;
  #users.extraGroups.vboxusers.members = [ "robbin" ];

  # Docker
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
  users.extraGroups.docker.members = ["robbin"];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enable window and desktop managers
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.libinput.enable = true;
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };
  security.pam.services.sddm.enableKwallet = true;
  programs.dconf.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
