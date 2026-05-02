{ self, inputs, ... }: {

  flake.nixosConfigurations.colby = inputs.nixpkgs.lib.nixosSystem {
    modules = [ 
      self.nixosModules.myMachineConfiguration
      self.nixosModules.myHomeManager
    ];
  };

}
