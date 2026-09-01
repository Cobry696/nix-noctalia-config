{ self, inputs, ... }:
{

  flake.nixosModules.colbyConfiguration =
    {
      config,
      pkgs,
      inputs,
      ...
    }:
    {
      # Edit this configuration file to define what should be installed on
      # your system.  Help is available in the configuration.nix(5) man page
      # and in the NixOS manual (accessible by running ‘nixos-help’).
      imports = [
        # Include the results of the hardware scan.
        self.nixosModules.colbyHardware
        self.nixosModules.niri
        # self.nixosModules.musnix
        # self.nixosModules.myFlatpaks
      ];
      # Enable flakes
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      # Bootloader.
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      # Use latest kernel.
      boot.kernelPackages = pkgs.linuxPackages_latest;

      networking.hostName = "nixos"; # Define your hostname.
      # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

      # Configure network proxy if necessary
      # networking.proxy.default = "http://user:password@proxy:port/";
      # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

      # enable bluetooth
      hardware.bluetooth.enable = true;
      hardware.bluetooth.powerOnBoot = true;

      # Enable networking
      networking.networkmanager.enable = true;

      # Enable battery monitoring
      services.upower.enable = true;

      # Enable automounting
      services.udisks2.enable = true;

      # Set your time zone.
      time.timeZone = "America/Halifax"; # "America/St_Johns"

      # Select internationalisation properties.
      i18n.defaultLocale = "en_CA.UTF-8";

      # Enable the X11 windowing system.
      services.xserver.enable = false;

      # Enable the GNOME Desktop Environment.
      #services.displayManager.gdm = {
      #  enable = true;
      #	wayland = true;
      #};
      #services.displayManager.gdm.wayland = true;
      services.displayManager.sddm = {
        enable = true;
        wayland.enable = true;
        settings.Wayland.CompositorCommand = "${pkgs.kdePackages.kwin}/bin/kwin_wayland --drm --no-lockscreen --no-global-shortcuts --locale1";
        theme = "sddm-astronaut-theme";
        extraPackages = [ pkgs.sddm-astronaut ];
      };
      programs.niri.enable = true;

      #services.xserver.desktopManager.gnome.enable = true;

      # Configure keymap in X11
      services.xserver.xkb = {
        layout = "us";
        variant = "";
      };

      services.hardware.openrgb = {
        enable = true;
      };

      # Enable CUPS to print documents.
      services.printing.enable = true;

      # Enable sound with pipewire.
      services.pulseaudio.enable = false;
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;

        # use the example session manager (no others are packaged yet so this is enabled by default,
        # no need to redefine it in your config for now)
        #media-session.enable = true;
      };

      xdg.portal.enable = true;
      xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

      # services.flatpak.enable = true;

      # environment.variables =
      #   let
      #     makePluginPath =
      #       format:
      #       (pkgs.lib.makeSearchPath format [
      #         "$HOME/.nix-profile/lib"
      #         "/run/current-system/sw/lib"
      #         "/etc/profiles/per-user/$USER/lib"
      #       ])
      #       + ":$HOME/.${format}";
      #   in
      #   {
      #     LV2_PATH = makePluginPath "lv2";
      #     VST3_PATH = makePluginPath "vst3";
      #     VST_PATH = makePluginPath "vst";
      #     LXVST_PATH = makePluginPath "lxvst";
      #   };

      services.flatpak = {
        enable = true;
        # Add the Flathub remote
        remotes = [
          {
            name = "flathub";
            location = "https://flathub.org/repo/flathub.flatpakrepo";
          }
        ];
        # Declare packages to install
        packages = [
          "net.lutris.Lutris"
          "com.github.tchx84.Flatseal"
          "io.github.revisto.drum-machine"
        ];
        # Optional: Update on system activation
        update.onActivation = true;
      };
      # Enable touchpad support (enabled default in most desktopManager).
      # services.xserver.libinput.enable = true;

      # Define a user account. Don't forget to set a password with ‘passwd’.
      users.users.colby = {
        isNormalUser = true;
        description = "Colby Pynn";
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
        packages = with pkgs; [
          #  thunderbird
        ];
      };

      services.tailscale.enable = true;

      # Install firefox.
      programs.firefox.enable = true;

      programs.steam = {
        enable = true;
        package = pkgs.steam;
        extraCompatPackages = with pkgs; [
          proton-ge-bin
        ];
      };

      programs.neovim = {
        enable = true;
        defaultEditor = true;
      };

      programs.git = {
        enable = true;
      };

      programs.vscode.package = pkgs.vscode.fhsWithPackages (
        ps: with ps; [
          lobster

        ]
      );

      programs.nix-ld.enable = true;
      programs.nix-ld.libraries = with pkgs; [
        # libwayland-dev
        wayland-protocols
        glfw
        #   stdenv.cc.cc.lib
        #   libGL
        #   libGLU
        #   libxkbcommon
        #   fontconfig
        #   libx11
        #   freetype
        #   dbus
        #   libxcb-cursor
        #   glib
        #   zstd

      ];

      environment.etc."gitconfig".text = ''
                [user]
        	        name = Cobry696
        	        email = colbypynn@gmail.com
      '';

      # Allow unfree packages
      nixpkgs.config.allowUnfree = true;

      # flatpak theming? According to nixos manual

      # List packages installed in system profile. To search, run:
      # $ nix search wget
      environment.systemPackages = with pkgs; [
        #vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
        wget
        sddm-astronaut
        kdePackages.dolphin
        wdisplays
        usbutils
        python3
        cargo
        rustc
        gcc
        fastfetch
        p7zip
        #wineWowPackages.stable
        curl
        unzip
        btop
        uv
        ffmpeg-full
        pavucontrol
        stdenv.cc.cc.lib
        libreoffice
      ];

      home-manager.users.colby = self.homeModules.colbyModule;

      # Some programs need SUID wrappers, can be configured further or are
      # started in user sessions.
      # programs.mtr.enable = true;
      # programs.gnupg.agent = {
      #   enable = true;
      #   enableSSHSupport = true;
      # };

      # List services that you want to enable:

      # Enable the OpenSSH daemon.
      # services.openssh.enable = true;

      # Open ports in the firewall.
      # networking.firewall.allowedTCPPorts = [ ... ];
      # networking.firewall.allowedUDPPorts = [ ... ];
      # Or disable the firewall altogether.
      # networking.firewall.enable = false;

      # This value determines the NixOS release from which the default
      # settings for stateful data, like file locations and database versions
      # on your system were taken. It‘s perfectly fine and recommended to leave
      # this value at the release version of the first install of this system.
      # Before changing this value read the documentation for this option
      # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
      system.stateVersion = "25.11"; # Did you read the comment?

    };

}
