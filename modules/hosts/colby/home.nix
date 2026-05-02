{ self, inputs, ... }: {

  flake.homeConfigurations.colby = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
    modules = [
      self.homeModules.colbyModule
      {
        home.username = "colby"
	home.homeDirectory = "/home/colby"
      };
    ];
  };

  flake.homeModules.colbyModule = { pkgs, ... }: {
    programs.bash = {
      enable = true;
      shellAliases.ls = "ls -la"
    };

    home.packages.pkgs = [
      blender
    ];

    home.pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      package = pkgs.rose-pine-cursor;
      name = "rose-pine-cursor";
      size = 16;
    };

    home.stateVersion = "25.11";
  };

};
