{ self, inputs, ... }:
{

  flake.nixosConfigurations.colby = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.nix-flatpak.nixosModules.nix-flatpak
      self.nixosModules.colbyConfiguration
      self.nixosModules.myHomeManager
      # self.nixosModules.myFlatpaks
    ];
  };

}
