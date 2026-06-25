{ inputs, ... }:
{

  imports = [
    # adds home-manager options to flake-parts
    inputs.home-manager.flakeModules.home-manager
    # inputs.nix-flatpak.nixosModules.nix-flatpak
  ];

  config = {
    systems = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
}
