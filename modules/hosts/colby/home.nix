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

  flake.homeModules.colbyModule = { pkgs, lib, ... }: {
    programs.bash = {
      enable = true;
      shellAliases.ls = "ls -la";
    };

    programs.helix = {
      enable = true;
      defaultEditor = true;
      settings = {
        theme = "autumn_night_transparent";
        editor.cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };
        keys = {
          normal = {
            Z.Z = ":wq";
            Z.Q = ":q!";
            C-s = ":w";
          };
        };
      };

      extraPackages = with pkgs; [
        (python3.withPackages (ps: with ps; [ python-lsp-server ]))
      ];

      languages = with pkgs; {
        language-server = {
          pylsp = {
            command = "pylsp";
          };
        };

        language = [
          {
            name = "nix";
            auto-format = true;
            formatter.command = lib.getExe pkgs.nixfmt-rfc-style;
          }
          {
            name = "python";
            auto-format = true;
            language-servers = [ "ruff" "pylsp" ]; # or "pyright"
            
            # Optional: Configure Ruff formatter
            formatter.command = "${pkgs.ruff}/bin/ruff";
            formatter.args = [ "format" "-" ];
            
            # Optional: Configure pylsp settings
            # Note: pylsp configuration is often handled via pylsp's own config files 
            # or by passing arguments if the LSP supports it.
          }
        ];
      };

      #"language-server.pylsp".command = "${pkgs.python3Packages.python-lsp-server}/bin/pylsp";

      themes = {
        autumn_night_transparent = {
          "inherits" = "autumn_night";
          "ui.background" = { };
        };
      };
    };

    programs.zellij.enable = true;

    programs.yazi.enable = true;

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
