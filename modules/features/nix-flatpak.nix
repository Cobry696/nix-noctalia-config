{ self, inputs, ... }:
{

  flake.nixosModules.myFlatpaks =
    { pkgs, ... }:
    {
      imports = [
        inputs.nix-flatpak.nixosModules.nix-flatpak
      ];

      services.flatpak.enable = true;
    };

}
