{
  self,
  inputs,
  ...
}:
{
  perSystem = { pkgs, ... }: {
    packages.myNoctalia = inputs.wrapper-modules.lib.wrapPackage {
      inherit pkgs;
      # The base package is the noctalia v5 package from its flake
      package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;

      # Add any necessary environment variables or wrapper flags here
      env = {
        # Example: Point Noctalia to a specific config directory
        NOCTALIA_CONFIG_DIR = ./noctalia.toml;
      };

      # You can add flags to the binary if needed
      flags = {
        # "--some-flag" = "value";
      };
    };
  };
}
