{ self, inputs, ... }: {

  flake.nixosConfigurations.colby = inputs.nixpkgs.lib.nixosSystem {
    modules = [ 
      self.nixosModules.colbyConfiguration
      self.nixosModules.myHomeManager
    ];
  };

}
