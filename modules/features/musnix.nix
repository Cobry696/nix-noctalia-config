{ self, inputs, ... }: {

  flake.nixosModules.musnix = { pkgs, ... }: {
    imports = [
      inputs.musnix.nixosModules.default
    ];

    musnix = {
      enable = true;
      kernel.realtime = false;
    };
  };

}
