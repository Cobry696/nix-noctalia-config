{ self, inputs, ... }:
{

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

  flake.homeModules.colbyModule =
    { pkgs, lib, ... }:
    {
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
            tailwindcss-ls = {
              command = "tailwindcss-language-server";
              args = [ "--stdio" ];
            };
            julia = {
              command = "julia";
              args = [
                "--project=@LanguageServer"
                "--startup-file=no"
                "--history-file=no"
                "-e"
                "using LanguageServer; runserver()"
              ];
            };
            # clangd = {
            #   command = "clangd";
            #   args = [ "--query-driver=/run/current-system/sw/bin/gcc,/usr/bin/clang" ];
            # };
          };

          language = [
            {
              name = "nix";
              auto-format = true;
              formatter.command = lib.getExe pkgs.nixfmt-rfc-style;
              language-servers = [
                "nil"
                "nixd"
              ];
            }
            {
              name = "python";
              auto-format = false;
              language-servers = [
                "ruff"
                "pylsp"
              ]; # or "pyright"

              # Optional: Configure Ruff formatter
              formatter.command = "${pkgs.ruff}/bin/ruff";
              formatter.args = [
                "format"
                "-"
              ];

              # Optional: Configure pylsp settings
              # Note: pylsp configuration is often handled via pylsp's own config files
              # or by passing arguments if the LSP supports it.
            }
            {
              name = "html";
              language-servers = [
                "superhtml"
                "tailwindcss-ls"
                "emmet-ls"
              ];
            }
            {
              name = "css";
              language-servers = [
                "tailwindcss-ls"
              ];
            }
            {
              name = "typescript";
              language-servers = [
                "tailwindcss-ls"
                "typescript-language-server"
              ];
            }
            {
              name = "svelte";
              language-servers = [
                "svelteserver"
                "tailwindcss-ls"
              ];
            }
            {
              name = "rust";
              language-servers = [ "rust-analyzer" ];
            }
            {
              name = "julia";
              language-servers = [ "julia" ];
            }
            # {
            #   name = "c";
            #   language-servers = [ "clangd" ];
            # }
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

      programs.mpv = {
        enable = true;
        # config = {
        #   audio-display = "no";
        #   opener = {
        #     audio = "mpv --force-window=no %f";
        #   };
        # };
      };

      programs.zellij.enable = true;

      programs.yazi = {
        enable = true;
        shellWrapperName = "yy";
        settings = {
          opener = {
            pdf_viewer = [
              {
                run = "tdf %s";
                block = true;
                desc = "Open with tdf";
                for = "unix";
              }
            ];
            python-runner = [
              {
                run = "uv run hx %s";
                block = true;
                desc = "Open with uv in venv";
                for = "unix";
              }
            ];
          };
          open = {
            prepend_rules = [
              {
                mime = "application/pdf";
                use = [ "pdf_viewer" ];
              }
              {
                url = "*.py";
                use = [ "python-runner" ];
              }
            ];
          };
        };
      };

      programs.ghostty = {
        enable = true;
        settings = {
          font-feature = [
            "-dlig"
            "-liga"
            "-calt"
          ];
        };
      };

      programs.emacs = {
        enable = true;
        extraPackages = epkgs: [
          epkgs.sage-shell-mode
        ];
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
        pkgs.remmina
        pkgs.yt-dlp
        pkgs.jellyfin
        pkgs.reaper
        pkgs.python314Packages.pudb
        pkgs.ob-xf
        pkgs.surge-xt
        pkgs.ollama
        pkgs.nodejs
        pkgs.direnv
        pkgs.inkscape
        pkgs.obsidian
        pkgs.bash-completion
        pkgs.nix-search-cli
        #cpkgs.intel-oneapi-toolkit
        pkgs.godot
        pkgs.julia-bin
        pkgs.lobster
        pkgs.sage
        pkgs.texliveFull
        pkgs.kdePackages.cantor
        pkgs.R
        pkgs.rstudio
        pkgs.gimp
        pkgs.qemu
        pkgs.distrobox
        pkgs.tdf
        pkgs.imagemagick
        pkgs.ghostscript

        pkgs.cemu
        pkgs.ukmm
        #pkgs.joycond
        pkgs.gamepad-tool
        pkgs.evtest
        # pkgs.emacs
        pkgs.mcpelauncher-ui-qt

        pkgs.superhtml
        pkgs.tailwindcss-language-server
        pkgs.typescript-language-server
        pkgs.svelte-language-server
        pkgs.vscode-langservers-extracted
        pkgs.emmet-ls
        pkgs.rust-analyzer
        # pkgs.llvmPackages.clang-unwrapped
        pkgs.nil
        pkgs.nixd
        pkgs.texlab

        pkgs.netcat
        pkgs.wireguard-tools
        pkgs.protonvpn-gui
        pkgs.wireshark

        pkgs.aseprite
      ];

      home.pointerCursor = {
        enable = true;
        gtk.enable = true;
        x11.enable = true;
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 16;
      };

      home.stateVersion = "25.11";
    };

}
