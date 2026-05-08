{self, inputs, ... }: {

  flake.homeConfigurations.colby = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
    modules = [
      self.homeModules.colbyModule
      {
        home.username = "colby";
	      home.homeDirectory = "/home/colby";
      }
    ];
  };

  flake.homeModules.colbyModule = { pkgs, ... }: {
    programs.bash = {
      enable = true;
      shellAliases.ls = "ls -la";
    };

    home.packages = [
      pkgs.blender
      pkgs.brave
      pkgs.discord
      pkgs.spotify
      pkgs.heroic
      pkgs.vscode
      pkgs.gamescope
      pkgs.grsync
      pkgs.openrgb
	    pkgs.prismlauncher
    ];

    home.pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 16;
    };

    home.stateVersion = "25.11";
  };

}
