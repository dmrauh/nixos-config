{ config, pkgs, ... }:

{
  imports = [
    ./fonts.nix
    ./hardware-configuration.nix
    ./packages.nix
    ./theme.nix
    ./uni-mount.nix
  ];

  fileSystems = {
    # Supposedly better for a SSD.
    "/".options = [ "noatime" "nodiratime" "discard" ];
  };

  boot = {
    loader = {
      timeout = 1;
      efi.canTouchEfiVariables = true;

      grub = { device = "nodev"; };
    };

    initrd.luks.devices = {
      pv = {
        device = "/dev/disk/by-uuid/4d449c1e-93ac-4cf7-aa3c-63ce4ab80013";
        preLVM = true;
        allowDiscards = true;
      };
    };

    kernelPackages = pkgs.linuxPackages_latest;
  };

  documentation.dev.enable = true;

  networking = {
    hostName = "oc215";
    networkmanager.enable = true;
    nameservers = [ "127.0.0.1" ]; # relay local queries to dnscrypt-proxy2
  };

  powerManagement.powertop.enable = true;

  users.users.dmrauh = {
    isNormalUser = true;
    home = "/home/dmrauh";
    description = "Dominik Rauh";
    extraGroups =
      [ "adbusers" "wheel" "networkmanager" "vboxusers" "docker" "video" ];
    shell = "/run/current-system/sw/bin/fish";
  };

  services = {

    compton = {
      enable = true;
      fade = true;
    };

    dnscrypt-proxy2 = {
      enable = true;
      settings = {
        sources.public-resolvers = {
          urls = [
            "https://download.dnscrypt.info/resolvers-list/v2/public-resolvers.md"
          ];
          cache_file = "public-resolvers.md";
          minisign_key =
            "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
          refresh_delay = 72;
        };
      };
    };

    fstrim.enable = true;

    smartd.enable = true;

    thermald.enable = true;

    upower.enable = true;

    xserver = {

      enable = true;
      libinput.enable = true;

      videoDrivers = [ "intel" ];
      deviceSection = ''
        Option "TearFree" "true"
      '';

      displayManager = {
        defaultSession = "none+i3";
        lightdm = {
          enable = true;
          autoLogin.enable = false;
          autoLogin.user = "dmrauh";
          autoLogin.timeout = 2;
        };
      };

      desktopManager.xterm.enable = false;

      windowManager = {
        i3.enable = true;
        i3.package = pkgs.i3-gaps;
      };
    };

    physlock.enable = true;

    redshift = {
      enable = true;
      temperature = {
        day = 6500;
        night = 2700;
      };
    };

    cron = {
      enable = true;
      systemCronJobs = [
        "*/5 * * * * dmrauh $HOME/bin/mailman"
        "*/5 * * * * dmrauh $HOME/bin/mailindexer"
        "*/5 * * * * dmrauh ${pkgs.vdirsyncer}/bin/vdirsyncer sync"
      ];
    };

    autorandr.enable = true;

    gnome3 = {
      gnome-keyring.enable = true;
      at-spi2-core.enable = true;
    };

    printing = {
      enable = true;
      drivers = with pkgs; [ brlaser gutenprint postscript-lexmark ];
    };

    udev = {
      # for light
      extraRules = ''
        				ACTION=="add", SUBSYSTEM=="backlight",
            RUN+="${pkgs.coreutils}/bin/chgrp video %S%p/brightness",
            RUN+="${pkgs.coreutils}/bin/chmod g+w %S%p/brightness"
        				'';

      path = with pkgs;
        [
          coreutils # for chgrp
        ];
    };
  };

  environment.variables = {
    BROWSER = "firefox";
    EDITOR = "e";
    SSL_CERT_FILE = "/etc/ssl/certs/ca-bundle.crt";
  };

  console = {
    font = "Fira Code Light";
    keyMap = "de";
  };

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";

    inputMethod = {
      ibus.engines = with pkgs.ibus-engines; [ m17n ];
      enabled = "ibus";
    };
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  location = {
    latitude = 48.3705;
    longitude = 10.8978;
  };

  virtualisation = {
    virtualbox.host = {
      enable = true;
      enableExtensionPack = true;
    };
  };

  security.pam.services.lightdm.enableGnomeKeyring = true;

  programs = {
    adb.enable = true;

    fish.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    seahorse.enable = true;

  };

  nixpkgs.config = {
    pulseaudio = true;
    allowUnfree = true;
  };

  hardware = {
    pulseaudio.enable = true;
    enableRedistributableFirmware = true;
    bluetooth.enable = false;
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.03"; # Did you read the comment?

}

