{ self, inputs, ... }:
{
  flake.nixosModules.nix-flatpak =
    { pkgs, ... }:
    {
      services.flatpak = {
        enable = true;
        # Add the Flathub remote
        remotes = [
          {
            name = "flathub";
            location = "https://flathub.org/repo/flathub.flatpakrepo";
          }
        ];
        # Declare packages to install
        packages = [
          "net.lutris.Lutris"
        ];
        # Optional: Update on system activation
        update.onActivation = true;
      };
    };
}
